import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'theme.dart';
import 'search_bar.dart';
import 'song_list.dart';
import 'lower_default.dart';

void main() {
  runApp(const MediaQuery(data: MediaQueryData(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Tunescape',
        theme:
            // MediaQuery.of(context).platformBrightness == Brightness.dark
            //     ? darkTheme
            //     :
            lightTheme,
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
  void initState() {
    super.initState();
    initDatabase();
  }

  void initDatabase() async {
    const url = 'https://song-recommendation-tunescape.herokuapp.com/api/';
    await http.get(
      Uri.parse('${url}loaddata'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 10.0),
              child: IconButton(
                splashRadius: 20,
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            );
          })
        ],
      ),
      endDrawer: Drawer(
        width: 400,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const SongListDrawer(),
      ),
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
                    top: MediaQuery.of(context).size.height / 2 - 200.0),
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'Tunescape',
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                    ))),
            const Center(child: SearchBar(width: 600)),
            const Expanded(child: DefaultLower(isLogo: true)),
          ],
        ),
      ),
    );
  }
}
