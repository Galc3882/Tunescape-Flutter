import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lower_default.dart';

class RecommendSongs extends StatefulWidget {
  const RecommendSongs({Key? key}) : super(key: key);

  @override
  State<RecommendSongs> createState() => _RecommendSongs();
}

class _RecommendSongs extends State<RecommendSongs> {
  List<List<String>> recommendSongs = [];
  bool isSearchResultsCompleted = false;

  @override
  void initState() {
    super.initState();
    getRecommendation();
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
                                left: 40.0, bottom: 10.0, top: 15.0),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: TextButton(
                                child: Text(
                                  textAlign: TextAlign.left,
                                  'Tunescape',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  maxLines: 1,
                                ),
                                onPressed: () => Navigator.of(context)
                                    .popUntil((route) => route.isFirst),
                              ),
                            )),
                      )),
            Expanded(
              flex: 0,
              child: (MediaQuery.of(context).size.width < 450 ||
                      MediaQuery.of(context).size.height < 450)
                  ? const SizedBox.shrink()
                  : Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 55.0),
                          child: Text(
                            textAlign: TextAlign.left,
                            'Recommended Songs',
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                          )),
                    ),
            ),
            Expanded(
              flex: 1,
              child: RecommendSongsContainer(
                  recommendSongs: recommendSongs,
                  isSearchResultsCompleted: isSearchResultsCompleted),
            ),
            const DefaultLower(isLogo: false),
          ],
        ),
      ),
    );
  }

  void getRecommendation() async {
    const url = 'https://song-recommendation-tunescape.herokuapp.com/api/';
    final prefs = await SharedPreferences.getInstance();
    final List<String>? songs = prefs.getStringList('songs');
    final String? songsString = songs?.join('\\u0000\\u0000');
    try {
      final response = await http.get(
        Uri.parse('${url}recommend?key=$songsString'),
      );
      if (response.statusCode == 200) {
        if (response.body.contains('array')) {
          JsonDecoder decoder = const JsonDecoder();
          setState(() {
            recommendSongs =
                ((decoder.convert(response.body)['array'] as List<dynamic>)
                    .map((e) {
              return (e as List<dynamic>).map((e) => e.toString()).toList();
            }).toList());

            isSearchResultsCompleted = true;
          });
        } else {
          setState(() {
            recommendSongs = [
              [response.body]
            ];
            isSearchResultsCompleted = true;
          });
        }
      }
    } catch (e) {
      Future.delayed(
          const Duration(seconds: 0),
          () => setState(() {
                isSearchResultsCompleted = true;
                recommendSongs = [
                  [e.toString()]
                ];
              }));
    }
  }
}

class RecommendSongsContainer extends StatefulWidget {
  final List<List<String>> recommendSongs;
  final bool isSearchResultsCompleted;
  const RecommendSongsContainer(
      {Key? key,
      required this.recommendSongs,
      required this.isSearchResultsCompleted})
      : super(key: key);

  @override
  State<RecommendSongsContainer> createState() => _RecommendSongsContainer();
}

class _RecommendSongsContainer extends State<RecommendSongsContainer> {
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
                ? widget.recommendSongs[0].length == 1
                    ? Text(widget.recommendSongs[0][0],
                        style: Theme.of(context).textTheme.bodyLarge)
                    : Material(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                        color: Theme.of(context).colorScheme.secondary,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          child: ListView.builder(
                            itemCount: widget.recommendSongs.length,
                            itemBuilder: (context, index) {
                              return listItem(context, index);
                            },
                          ),
                        ),
                      )
                : SizedBox(
                    height: (MediaQuery.of(context).size.width < 450 ||
                            MediaQuery.of(context).size.height < 450)
                        ? 100.0
                        : 200.0,
                    width: (MediaQuery.of(context).size.width < 450 ||
                            MediaQuery.of(context).size.height < 450)
                        ? 100.0
                        : 200.0,
                    child: const LoadingIndicator(
                      indicatorType: Indicator.audioEqualizer,
                    )),
          ),
        ),
      ),
    );
  }

  Widget listItem(BuildContext context, int index) {
    return Column(children: [
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
      Padding(
        padding: (MediaQuery.of(context).size.width < 450 ||
                MediaQuery.of(context).size.height < 450)
            ? const EdgeInsets.only(left: 10.0, bottom: 10.0, top: 10.0)
            : const EdgeInsets.only(
                left: 35.0, right: 35.0, bottom: 15.0, top: 10.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: (MediaQuery.of(context).size.width < 450 ||
                            MediaQuery.of(context).size.height < 450)
                        ? const EdgeInsets.only(bottom: 5.0)
                        : const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                        widget.recommendSongs[index][0].split('\u0000')[0],
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        textScaleFactor:
                            (MediaQuery.of(context).size.width < 450 ||
                                    MediaQuery.of(context).size.height < 450)
                                ? 0.7
                                : 1),
                  ),
                  Text(
                    widget.recommendSongs[index][0].split('\u0000')[1],
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    textScaleFactor: (MediaQuery.of(context).size.width < 450 ||
                            MediaQuery.of(context).size.height < 450)
                        ? 0.6
                        : 0.7,
                  ),
                ],
              ),
            ),
          ),
          LinearPercentIndicator(
            center: Text(
                '${widget.recommendSongs[index][1][widget.recommendSongs[index][1].indexOf('.') + 1] + widget.recommendSongs[index][1][widget.recommendSongs[index][1].indexOf('.') + 2]}%',
                style: Theme.of(context).textTheme.labelSmall),
            width: (MediaQuery.of(context).size.width < 450 ||
                    MediaQuery.of(context).size.height < 450)
                ? 100.0
                : 150.0,
            animation: true,
            lineHeight: (MediaQuery.of(context).size.width < 450 ||
                    MediaQuery.of(context).size.height < 450)
                ? 15.0
                : 20.0,
            curve: Curves.easeInOut,
            animationDuration: 1000,
            percent: double.parse(widget.recommendSongs[index][1]),
            barRadius: const Radius.circular(16),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            progressColor: Color([
              0xFFFF0D0D,
              0xFFfefb01,
              0xFFcefb02,
              0xFF87fa00,
              0xFF3af901,
              0xFF00ED01
            ][max(
                0,
                (((double.parse(widget.recommendSongs[index][1]) - 0.67) * 15)
                    .round()))]),
          ),
        ]),
      )
    ]);
  }
}
