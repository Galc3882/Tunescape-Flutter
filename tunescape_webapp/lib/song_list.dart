import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animated_icon/simple_animated_icon.dart';
import 'recommend_songs.dart';

class SongListDrawer extends StatefulWidget {
  const SongListDrawer({Key? key}) : super(key: key);

  @override
  State<SongListDrawer> createState() => _SongListDrawer();
}

class _SongListDrawer extends State<SongListDrawer>
    with TickerProviderStateMixin {
  List<String> savedSongs = [];
  bool edit = false;

  final List<AnimationController> _animController = [];
  final List<Animation<double>> _progress = [];

  @override
  void initState() {
    super.initState();
    savedSongs = [];
    edit = false;
    getSongs();
  }

  @override
  void dispose() {
    for (var i = 0; i < _animController.length; i++) {
      _animController[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 5.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  splashRadius: 20,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                savedSongs.isEmpty
                    ? const SizedBox.shrink()
                    : InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            edit = !edit;
                            if (edit) {
                              for (var j = 0; j < _animController.length; j++) {
                                _animController[j].forward();
                              }
                              _animController[savedSongs.length].forward();
                            } else {
                              for (var j = 0; j < _animController.length; j++) {
                                _animController[j].reverse();
                              }
                              _animController[savedSongs.length].reverse();
                            }
                          });
                        },
                        child: SimpleAnimatedIcon(
                          startIcon: Icons.edit,
                          endIcon: Icons.edit_off,
                          progress: _progress[savedSongs.length],
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 30,
                        ),
                      ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 20, left: 20.0, right: 20.0, bottom: 10.0),
          child: Text(
            textAlign: TextAlign.left,
            savedSongs.isEmpty ? 'No songs added to list' : 'Saved songs: ',
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
          ),
        ),
        Expanded(
          child: ListView.builder(
              controller: ScrollController(),
              itemCount: savedSongs.length,
              itemBuilder: (context, index) {
                return savedSongContainer(index);
              }),
        ),
        savedSongs.isNotEmpty
            ? Center(
                child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25.7))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 13.0, left: 15.0, right: 15.0),
                    child: InkWell(
                        child: Text('Recommend',
                            style: Theme.of(context).textTheme.bodyMedium),
                        onTap: () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (c, a1, a2) =>
                                    const RecommendSongs(),
                                transitionsBuilder: (c, anim, a2, child) =>
                                    FadeTransition(opacity: anim, child: child),
                                transitionDuration:
                                    const Duration(milliseconds: 500),
                              ));
                        }),
                  ),
                ),
              ))
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget savedSongContainer(int i) {
    return Column(
      children: [
        i == 0
            ? const SizedBox.shrink()
            : Center(
                child: Container(
                height: 1.0,
                width: (MediaQuery.of(context).size.width < 450 ||
                        MediaQuery.of(context).size.height < 450)
                    ? MediaQuery.of(context).size.width - 50.0
                    : 370,
                color: Theme.of(context).colorScheme.outline,
              )),
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(
                        savedSongs[i].split('\u0000')[0],
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textScaleFactor:
                            (MediaQuery.of(context).size.width < 450 ||
                                    MediaQuery.of(context).size.height < 450)
                                ? 0.7
                                : 0.95,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        textAlign: TextAlign.left,
                        savedSongs[i].split('\u0000')[1],
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textScaleFactor:
                            (MediaQuery.of(context).size.width < 450 ||
                                    MediaQuery.of(context).size.height < 450)
                                ? 0.6
                                : 0.7,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: SizedBox(
                    width: 50,
                    child: CircleAvatar(
                        radius: _progress[i].value,
                        backgroundColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            removeSong(savedSongs[i]);
                            setState(() {
                              savedSongs.removeAt(i);
                            });
                          },
                          child: edit
                              ? Center(
                                  child: AnimatedOpacity(
                                    curve: Curves.easeInExpo,
                                    duration: const Duration(milliseconds: 200),
                                    opacity:
                                        _progress[i].value == 0.0 ? 0.0 : 1.0,
                                    child: Icon(
                                      size: _progress[i].value,
                                      Icons.delete,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        )),
                  ))
            ],
          ),
        ),
      ],
    );
  }

  void getSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? songs = prefs.getStringList('songs');
    setState(() {
      savedSongs = songs ?? [];

      for (int i = 0; i < savedSongs.length; i++) {
        _animController.add(AnimationController(
            vsync: this, duration: const Duration(milliseconds: 60)));
        _progress.add(Tween(begin: 0.0, end: 22.0).animate(
            CurvedAnimation(parent: _animController[i], curve: Curves.easeIn))
          ..addListener(() {
            setState(() {});
          }));
      }
      if (savedSongs.isNotEmpty) {
        _animController.add(AnimationController(
            vsync: this, duration: const Duration(milliseconds: 200)));
        _progress.add(Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: _animController[savedSongs.length], curve: Curves.easeIn))
          ..addListener(() {
            setState(() {});
          }));
      }
    });
  }

  void removeSong(String key) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? songs = prefs.getStringList('songs');
    if (songs != null) {
      songs.remove(key);
      await prefs.setStringList('songs', songs);
    }
  }
}
