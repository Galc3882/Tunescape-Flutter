import 'dart:io';

import 'package:flutter/material.dart';
import 'main.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          MediaQuery.of(context).size.width < mobileWidth
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
                ),
          MediaQuery.of(context).size.width < mobileWidth
              ? Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                  child: SearchBar(
                    width: MediaQuery.of(context).size.width,
                    query: widget.query,
                  ),
                )
              : SearchBar(
                  width: MediaQuery.of(context).size.width,
                  query: widget.query,
                ),
          MediaQuery.of(context).size.width < mobileWidth
              ? const SizedBox.shrink()
              : Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 55.0, top: 15.0),
                      child: Text(
                        textAlign: TextAlign.left,
                        isSearchResultsCompleted
                            ? results[0].length == 1
                                ? 'Found 1 song: '
                                : 'Found ${results[0].length} songs: '
                            : 'Searching...',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                      )),
                ),
          SearchResultsContainer(
              isSearchResultsCompleted: isSearchResultsCompleted,
              results: results),
        ],
      ),
    );
  }

  // make api request to get search results
  void getSearchResults(String query) async {
    try {
      // final response = await http.get(
      //   'https://tunescape.herokuapp.com/search?query=$query',
      // );
      // if (response.statusCode == 200) {
      //   final json = jsonDecode(response.body);
      //   final results = json['results'] as List<dynamic>;
      //   final resultList = <List<String>>[];
      sleep(const Duration(seconds: 5));
      setState(() {
        isSearchResultsCompleted = true;
        results = [
          ['Song 1', 'Band 1'],
          ['Song 2', 'Band 2'],
          ['Song 3', 'Band 3']
        ];
      });
    } catch (e) {
      setState(() {
        isSearchResultsCompleted = true;
        results = [
          [e.toString()]
        ];
      });
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

class _SearchResultsContainer extends State<SearchResultsContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).size.width < mobileWidth
          ? const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0)
          : const EdgeInsets.only(left: 35.0, right: 35.0, top: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.all(Radius.circular(3.0))),
        child: Center(
          child: widget.isSearchResultsCompleted
              ? widget.results[0].length == 1
                  ? Text(widget.results[0][0],
                      style: Theme.of(context).textTheme.bodyLarge)
                  : ListView.builder(
                      itemCount: widget.results[0].length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(widget.results[0][index]),
                        );
                      },
                    )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
