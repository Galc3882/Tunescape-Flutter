import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:simple_animated_icon/simple_animated_icon.dart';

import 'search_bar.dart';

class SearchResults extends StatefulWidget {
  final String query;

  const SearchResults({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResults();
}

class _SearchResults extends State<SearchResults> {
  List<List<String>> results = [[]];
  bool isSearchResultsCompleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSearchResults(widget.query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil((route) => route.isFirst);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Column(
          children: [
            Expanded(
                flex: 0,
                child: (MediaQuery.of(context).size.width < 450 ||
                        MediaQuery.of(context).size.height < 450)
                    ? const SizedBox.shrink()
                    : Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 55.0, top: 35.0, bottom: 10.0),
                            child: Text(
                              textAlign: TextAlign.left,
                              'Tunescape',
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                            )),
                      )),
            Expanded(
              flex: 0,
              child: (MediaQuery.of(context).size.width < 450 ||
                      MediaQuery.of(context).size.height < 450)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: SearchBar(
                        width: MediaQuery.of(context).size.width,
                        query: widget.query,
                      ),
                    )
                  : SearchBar(
                      width: MediaQuery.of(context).size.width,
                      query: widget.query,
                    ),
            ),
            Expanded(
              flex: 0,
              child: (MediaQuery.of(context).size.width < 450 ||
                      MediaQuery.of(context).size.height < 450)
                  ? const SizedBox.shrink()
                  : Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 55.0, top: 15.0),
                          child: Text(
                            textAlign: TextAlign.left,
                            'Search results',
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                          )),
                    ),
            ),
            Expanded(
              flex: 1,
              child: SearchResultsContainer(
                  isSearchResultsCompleted: isSearchResultsCompleted,
                  results: results),
            ),
          ],
        ),
      ),
    );
  }

  // make api request to get search results
  void getSearchResults(String query) async {
    const url = 'https://song-recommendation-tunescape.herokuapp.com/api/';
    try {
      final response = await http.get(
        Uri.parse('${url}songs?name=$query'),
      );
      if (response.statusCode == 200) {
        if (response.body.contains('array')) {
          JsonDecoder decoder = const JsonDecoder();
          setState(() {
            results =
                ((decoder.convert(response.body)['array'] as List<dynamic>)
                    .map((e) {
              return (e as List<dynamic>).map((e) => e.toString()).toList();
            }).toList());

            isSearchResultsCompleted = true;
          });
        } else {
          var response = await http.get(
            Uri.parse('${url}loaddata'),
          );
          response = await http.get(
            Uri.parse('${url}songs?name=$query'),
          );
          if (response.body.contains('array')) {
            JsonDecoder decoder = const JsonDecoder();
            setState(() {
              results =
                  ((decoder.convert(response.body)['array'] as List<dynamic>)
                      .map((e) {
                return (e as List<dynamic>).map((e) => e.toString()).toList();
              }).toList());

              isSearchResultsCompleted = true;
            });
          } else {
            setState(() {
              results = [
                [response.body]
              ];
              isSearchResultsCompleted = true;
            });
          }
        }
      }
    } catch (e) {
      Future.delayed(
          const Duration(seconds: 0),
          () => setState(() {
                isSearchResultsCompleted = true;
                results = [
                  [e.toString()]
                ];
              }));
    }
  }
}

class SearchResultsContainer extends StatefulWidget {
  final bool isSearchResultsCompleted;
  final List<List<String>> results;
  const SearchResultsContainer(
      {Key? key, required this.isSearchResultsCompleted, required this.results})
      : super(key: key);

  @override
  State<SearchResultsContainer> createState() => _SearchResultsContainer();
}

class _SearchResultsContainer extends State<SearchResultsContainer>
    with TickerProviderStateMixin {
  List<int> addedSongs = [];

  List<String>? initialSavedSongs = [];

  bool isInit = false;
  final List<AnimationController> _animController = [];
  final List<Animation<double>> _progress = [];

  @override
  void initState() {
    super.initState();
    getSavedSongs();
  }

  @override
  void dispose() {
    if (isInit) {
      for (var i = 0; i < _animController.length; i++) {
        _animController[i].dispose();
      }
    }
    super.dispose();
  }

  void getSavedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      initialSavedSongs = prefs.getStringList('songs');
    });
  }

  void animInit() {
    if (!isInit) {
      for (int i = 0; i < widget.results.length; i++) {
        _animController.add(AnimationController(
            vsync: this, duration: const Duration(milliseconds: 200)));
        _progress.add(Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: _animController[i], curve: Curves.easeIn))
          ..addListener(() {
            setState(() {});
          }));
        if (songSaved(i)) {
          _animController[i].forward(from: 1);
          addedSongs.add(i);
        }
      }
      isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: (MediaQuery.of(context).size.width < 450 ||
              MediaQuery.of(context).size.height < 450)
          ? const EdgeInsets.only(left: 10.0, right: 10.0)
          : const EdgeInsets.only(left: 35.0, right: 35.0),
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 0.95,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.all(Radius.circular(5.0))),
          child: Center(
            child: widget.isSearchResultsCompleted
                ? widget.results[0].length == 1
                    ? Text(widget.results[0][0],
                        style: Theme.of(context).textTheme.bodyLarge)
                    : Material(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                        color: Theme.of(context).colorScheme.secondary,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          child: ListView.builder(
                            itemCount: widget.results.length,
                            itemBuilder: (context, index) {
                              return listItem(context, index);
                            },
                          ),
                        ),
                      )
                : SizedBox(
                    height: 60.0,
                    width: 60.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 6.0,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    )),
          ),
        ),
      ),
    );
  }

  Widget listItem(context, index) {
    return Column(
      children: [
        index == 0
            ? const SizedBox.shrink()
            : Center(
                child: Container(
                height: 1.0,
                width: (MediaQuery.of(context).size.width < 450 ||
                        MediaQuery.of(context).size.height < 450)
                    ? MediaQuery.of(context).size.width - 50.0
                    : MediaQuery.of(context).size.width - 100.0,
                color: Theme.of(context).colorScheme.outline,
              )),
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          hoverColor: Theme.of(context).colorScheme.onTertiary,
          selectedTileColor: Theme.of(context).colorScheme.onTertiaryContainer,
          contentPadding: (MediaQuery.of(context).size.width < 450 ||
                  MediaQuery.of(context).size.height < 450)
              ? const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0)
              : const EdgeInsets.only(
                  left: 35.0, right: 35.0, bottom: 15.0, top: 5.0),
          dense: true,
          visualDensity: const VisualDensity(vertical: 4.0),
          leading: Container(
            width: 65,
            height: 65,
            color: Colors.white,
            child: const Center(
              child: Icon(
                Icons.music_note,
                size: 30,
              ),
            ),
          ),
          title: Text(
            widget.results[index][0],
            style: Theme.of(context).textTheme.bodyMedium,
            textScaleFactor: (MediaQuery.of(context).size.width < 450 ||
                    MediaQuery.of(context).size.height < 450)
                ? 0.7
                : 1,
          ),
          subtitle: Text(
            widget.results[index][1],
            style: Theme.of(context).textTheme.bodyMedium,
            textScaleFactor: (MediaQuery.of(context).size.width < 450 ||
                    MediaQuery.of(context).size.height < 450)
                ? 0.6
                : 0.7,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: (MediaQuery.of(context).size.width < 450 ||
                        MediaQuery.of(context).size.height < 450)
                    ? 40.0
                    : 50.0,
                width: (MediaQuery.of(context).size.width < 450 ||
                        MediaQuery.of(context).size.height < 450)
                    ? 40.0
                    : 50.0,
                child: Material(
                  borderRadius: BorderRadius.circular(25.7),
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25.7),
                    hoverColor: Theme.of(context).colorScheme.onSurface,
                    onTap: () {
                      animInit();
                      if (addedSongs.contains(index)) {
                        setState(() {
                          if (_animController[index].isAnimating) {
                            _animController[index].stop();
                          }
                          _animController[index].reverse();

                          addedSongs.remove(index);
                          removeSong(
                              '${widget.results[index][0]}\u0000${widget.results[index][1]}');
                        });
                      } else {
                        setState(() {
                          if (_animController[index].isAnimating) {
                            _animController[index].stop();
                          }
                          _animController[index].forward();
                          addedSongs.add(index);
                          addSong(
                              '${widget.results[index][0]}\u0000${widget.results[index][1]}');
                        });
                      }
                    },
                    child: (_progress.isEmpty)
                        ? Icon(
                            songSaved(index) ? Icons.check : Icons.add,
                            size: (MediaQuery.of(context).size.width < 450 ||
                                    MediaQuery.of(context).size.height < 450)
                                ? 30.0
                                : 35.0,
                            color: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                          )
                        : Center(
                            child: SimpleAnimatedIcon(
                              startIcon: Icons.add,
                              endIcon: Icons.check,
                              progress: _progress[index],
                              size: (MediaQuery.of(context).size.width < 450 ||
                                      MediaQuery.of(context).size.height < 450)
                                  ? 30.0
                                  : 35.0,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onTertiaryContainer,
                            ),
                          ),
                  ),
                ),
              )
            ],
          ),
          tileColor: Colors.transparent,
          onTap: () {
            // TODO: Add functionality to show song
          },
        ),
      ],
    );
  }

  songSaved(index) {
    if (initialSavedSongs != null) {
      if (initialSavedSongs!.contains(
          '${widget.results[index][0]}\u0000${widget.results[index][1]}')) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}

void addSong(String key) async {
  final prefs = await SharedPreferences.getInstance();
  final List<String>? songs = prefs.getStringList('songs');
  if (songs == null) {
    await prefs.setStringList('songs', <String>[key]);
  } else {
    if (!songs.contains(key)) {
      songs.add(key);
      await prefs.setStringList('songs', songs);
    }
  }
}

void removeSong(String key) async {
  final prefs = await SharedPreferences.getInstance();
  final List<String>? songs = prefs.getStringList('songs');
  if (songs != null) {
    songs.remove(key);
    await prefs.setStringList('songs', songs);
  }
}
