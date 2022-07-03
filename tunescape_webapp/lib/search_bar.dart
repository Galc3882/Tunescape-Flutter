import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'widget_size.dart';
import 'search_results.dart';

class SearchBar extends StatefulWidget {
  final double width;
  final String? query;
  const SearchBar({Key? key, required this.width, this.query})
      : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBar();
}

class _SearchBar extends State<SearchBar> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  bool isSearchButtonDisabled = true;
  bool hasSearchFocus = false;
  bool hasHover = false;

  late AnimationController _animController;
  late Animation<double> curve;
  late Animation<Color?> colorTween;

  late AnimationController _sizeController;
  late Animation<double> sizeCurve;
  late Animation<double> widthTween;

  @override
  void initState() {
    super.initState();
    isSearchButtonDisabled = true;
    hasSearchFocus = false;
    hasHover = false;

    _animController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    curve = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    colorTween =
        ColorTween(begin: const Color(0xFFD7E2FF), end: const Color(0xFFFFFFFF))
            .animate(curve)
          ..addListener(() {
            setState(() {});
          });

    _sizeController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    sizeCurve = CurvedAnimation(parent: _sizeController, curve: Curves.easeIn);
    widthTween = Tween<double>(begin: 25, end: 30).animate(sizeCurve)
      ..addListener(() {
        setState(() {});
      });

    // TODO: add support to double click to select word and tripple click to select line

    //!aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    _textController.text = 'dart';

    isSearchButtonDisabled = false;
    hasSearchFocus = false;
    //!aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

    if (widget.query != null) {
      _textController.text = widget.query!;
      isSearchButtonDisabled = false;
      hasSearchFocus = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MeasureSize(
        onChange: (size) {
          setState(() {
            myChildSize = size;
          });
        },
        child: Padding(
          padding: (MediaQuery.of(context).size.width < 450 ||
                  MediaQuery.of(context).size.height < 450)
              ? const EdgeInsets.only(left: 10.0, right: 10.0)
              : const EdgeInsets.only(left: 35.0, right: 35.0),
          child: SizedBox(
            width: widget.width,
            child: Container(
              height: (MediaQuery.of(context).size.width < 450 ||
                      MediaQuery.of(context).size.height < 450)
                  ? 35
                  : 45,
              decoration: BoxDecoration(
                  color: colorTween.value,
                  borderRadius: const BorderRadius.all(Radius.circular(25.7))),
              child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {
                        hasSearchFocus = hasFocus;
                        if (defaultTargetPlatform == TargetPlatform.iOS ||
                            defaultTargetPlatform == TargetPlatform.android ||
                            MediaQuery.of(context).size.width < 450 ||
                            MediaQuery.of(context).size.height < 450) {
                          if (hasFocus) {
                            _animController.forward();
                          } else {
                            _animController.reverse();
                          }
                        } else if (!hasSearchFocus) {
                          if (_animController.isAnimating) {
                            _animController.stop();
                          }
                          if (hasHover) {
                            _animController.forward();
                          } else {
                            _animController.reverse();
                          }
                        }
                      });
                    },
                    child: InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25.7)),
                      onTap: () {},
                      onHover: ((value) {
                        setState(() {
                          hasHover = value;
                          if (!hasSearchFocus) {
                            if (_animController.isAnimating) {
                              _animController.stop();
                            }
                            if (hasHover) {
                              _animController.forward();
                            } else {
                              _animController.reverse();
                            }
                          }
                        });
                      }),
                      child: TextFormField(
                        mouseCursor: SystemMouseCursors.text,
                        enableInteractiveSelection: true,
                        controller: _textController,
                        textAlign: TextAlign.left,
                        autovalidateMode: AutovalidateMode.always,
                        style: Theme.of(context).textTheme.bodySmall,
                        decoration: InputDecoration(
                          contentPadding:
                              (MediaQuery.of(context).size.width < 450 ||
                                      MediaQuery.of(context).size.height < 450)
                                  ? const EdgeInsets.only(top: -15.0)
                                  : const EdgeInsets.only(top: -4.0),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          icon: SizedBox(
                            height: 50,
                            width: 35,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, bottom: 5, top: 7, right: 0),
                              child: isSearchButtonDisabled != true
                                  ? InkWell(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      onTap: () {
                                        if (hasSearchFocus) {
                                          setState(() {
                                            isSearchButtonDisabled = true;
                                            _textController.text = '';
                                          });
                                        } else {
                                          _animController.reverse();
                                          submitQuery(_textController.text);
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          TextEditingController().clear();
                                        }
                                      },
                                      onHover: (hover) {
                                        setState(() {
                                          if (_animController.isAnimating) {
                                            _sizeController.stop();
                                          }
                                          if (hover) {
                                            _sizeController.forward();
                                          } else {
                                            _sizeController.reverse();
                                          }
                                        });
                                      },
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          hasSearchFocus == false
                                              ? Icons.search
                                              : Icons.close,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          size: widthTween.value,
                                        ),
                                      ))
                                  : Icon(
                                      Icons.search,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                            ),
                          ),
                          hintText: myChildSize == Size.zero
                              ? 'Search for a song...'
                              : (MediaQuery.of(context).size.width < 450 ||
                                      MediaQuery.of(context).size.height < 450)
                                  ? 'Search for a song...'
                                  : 'Search for a song... or piece... or artist...',
                          hintStyle: Theme.of(context).textTheme.labelSmall,
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            (value == null || value.isEmpty)
                                ? isSearchButtonDisabled = true
                                : isSearchButtonDisabled = false;
                          });
                        },
                        onFieldSubmitted: (String? value) {
                          _animController.reverse();
                          FocusScope.of(context).requestFocus(FocusNode());
                          TextEditingController().clear();
                          submitQuery(value ?? '');
                        },
                        // validator: (String? value) {
                        //   return value != null
                        //       ? value.contains('@')
                        //           ? 'Do not use the @ char.'
                        //           : null
                        //       : null;
                        // },
                      ),
                    ),
                  )),
            ),
          ),
        ));
  }

  // function that opens a new page on submit query
  void submitQuery(String query) {
    if (query.isNotEmpty && query != '') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                TextEditingController().clear();
              },
              child: SearchResults(query: query),
            ),
          ));
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _sizeController.dispose();
    _animController.dispose();
    super.dispose();
  }
}
