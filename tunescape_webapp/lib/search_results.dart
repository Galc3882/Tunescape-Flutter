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
                          isSearchResultsCompleted
                              ? results[0].length == 1
                                  ? 'Found 1 song: '
                                  : 'Found ${results.length} songs: '
                              : 'Searching...',
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
      Future.delayed(
          const Duration(seconds: 2),
          () => setState(() {
                isSearchResultsCompleted = true;
                results = [
                  ['Song 1', 'Band 1'],
                  ['Song 2', 'Band 2'],
                  ['Song 3', 'Band 3'],
                  ['Song 4', 'Band 4'],
                  ['Song 5', 'Band 5'],
                  ['Song 6', 'Band 6'],
                  ['Song 7', 'Band 7'],
                  ['Song 8', 'Band 8'],
                  ['Song 9', 'Band 9'],
                  ['Song 10', 'Band 10'],
                  ['Song 11', 'Band 11'],
                  ['Song 12', 'Band 12'],
                  ['Song 13', 'Band 13'],
                  ['Song 14', 'Band 14'],
                  ['Song 15', 'Band 15'],
                ];
              }));
    } catch (e) {
      Future.delayed(
          const Duration(seconds: 2),
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

class _SearchResultsContainer extends State<SearchResultsContainer> {
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
              // gradient:
              // RadialGradient(
              //     radius: MediaQuery.of(context).size.width / 4 - 200,
              //     colors: [
              //       Theme.of(context).colorScheme.primaryContainer,
              //       Theme.of(context).colorScheme.secondary
              //     ]),
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.all(Radius.circular(3.0))),
          child: Center(
            child: widget.isSearchResultsCompleted
                ? widget.results[0].length == 1
                    ? Text(widget.results[0][0],
                        style: Theme.of(context).textTheme.bodyLarge)
                    : ListView.builder(
                        // shrinkWrap: true,
                        itemCount: widget.results.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(widget.results[index][0],
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        },
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
}
