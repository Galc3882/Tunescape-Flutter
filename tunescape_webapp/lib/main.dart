import 'package:flutter/material.dart';

import 'theme.dart';
import 'widget_size.dart';
import 'search_results.dart';

void main() {
  runApp(const MediaQuery(data: MediaQueryData(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Tunescape',
        theme: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? darkTheme
            : lightTheme,
        home: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              TextEditingController().clear();
            },
            child: const MyHomePage()));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(
                    left: 35.0,
                    right: 35.0,
                    bottom: 10.0,
                    top: MediaQuery.of(context).size.height / 2 - 150.0),
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'Tunescape',
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                    ))),
            const Center(child: SearchBar(width: 600)),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final double width;
  final String? query;
  const SearchBar({Key? key, required this.width, this.query})
      : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBar();
}

class _SearchBar extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool isSearchButtonDisabled = true;
  bool hasSearchFocus = false;
  bool hasHover = false;

  @override
  void initState() {
    super.initState();
    isSearchButtonDisabled = true;
    hasSearchFocus = false;
    hasHover = false;

    // //!aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    // _controller.text = 'dart';
    // isSearchButtonDisabled = false;
    // hasSearchFocus = false;
    // //!aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

    if (widget.query != null) {
      _controller.text = widget.query!;
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
                  color: hasSearchFocus || hasHover
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.all(Radius.circular(25.7))),
              child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {
                        hasSearchFocus = hasFocus;
                      });
                    },
                    child: InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25.7)),
                      onTap: () {},
                      onHover: ((value) {
                        setState(() {
                          hasHover = value;
                        });
                      }),
                      child: TextFormField(
                        controller: _controller,
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
                                  left: 10, bottom: 5, top: 7, right: 0),
                              child: isSearchButtonDisabled != true
                                  ? hasSearchFocus == false
                                      ? IconButton(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            submitQuery(_controller.text);
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            TextEditingController().clear();
                                          },
                                          icon: Icon(
                                            Icons.search,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ))
                                      : IconButton(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            setState(() {
                                              isSearchButtonDisabled = true;
                                            });
                                            _controller.text = '';
                                          },
                                          icon: const Icon(Icons.close))
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
    _controller.dispose();
    super.dispose();
  }
}
