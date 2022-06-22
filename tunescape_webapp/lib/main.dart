import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'color_schemes.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

final _key = GlobalKey();
void main() {
  runApp(const MediaQuery(data: MediaQueryData(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // hide keyboard in case of overflow
    // final isKeyboard = MediaQuery.of(context).viewInsets.bottom != false;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: MediaQuery.of(context).platformBrightness == Brightness.dark
          ? darkTheme
          : lightTheme,
      home: const MyHomePage(),
    );
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(35.0),
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'Tunescape',
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                    ))),
            SizedBox(
                height: MediaQuery.of(context).size.height * 1 / 3,
                child: Center(
                    child: buildFloatingSearchBar(
                  context,
                  // _key,
                ))),
          ],
        ),
      ),
    );
  }
}

Widget buildFloatingSearchBar(context) {
  // final size = key.currentContext!.size;
  return FloatingSearchBar(
    hint: // size == null
        // ? 'Search'
        // : size.width > 50
        'Search for a song... or piece... or artist...',
    // : 'Search for a song...',
    hintStyle: Theme.of(context).textTheme.labelSmall,
    scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
    transitionDuration: const Duration(milliseconds: 800),
    transitionCurve: Curves.easeInOut,
    physics: const BouncingScrollPhysics(),
    axisAlignment: 0.0,
    openAxisAlignment: 0.0,
    width: 600,
    debounceDelay: const Duration(milliseconds: 500),
    onQueryChanged: (query) {
      // Call your model, bloc, controller here.
    },
    // Specify a custom transition to be used for
    // animating between opened and closed stated.
    transition: CircularFloatingSearchBarTransition(),
    actions: [
      FloatingSearchBarAction(
        showIfOpened: false,
        child: CircularButton(
          icon: const Icon(Icons.gpp_maybe_sharp),
          onPressed: () {},
        ),
      ),
      FloatingSearchBarAction.searchToClear(
        showIfClosed: false,
      ),
    ],
    builder: (context, transition) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Colors.white,
          elevation: 4.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: Colors.accents.map((color) {
              return Container(height: 112, color: color);
            }).toList(),
          ),
        ),
      );
    },
  );
}
