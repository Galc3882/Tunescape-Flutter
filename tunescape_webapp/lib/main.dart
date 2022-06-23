import 'package:flutter/material.dart';

import 'theme.dart';
import 'widget_size.dart';

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
  final TextEditingController _controller = TextEditingController();
  bool isSearchButtonDisabled = true;
  int mobileWidth = 430;

  @override
  void initState() {
    super.initState();
    isSearchButtonDisabled = true;
  }

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
            Center(
                child: MeasureSize(
                    onChange: (size) {
                      setState(() {
                        myChildSize = size;
                      });
                    },
                    child: buildSearchBar(context, myChildSize))),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar(context, Size myChildSize) {
    return Padding(
      padding: const EdgeInsets.only(right: 35.0, left: 35.0),
      child: SizedBox(
        width: 600.0,
        child: Container(
            height: MediaQuery.of(context).size.width < mobileWidth ? 35 : 50,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(25.7))),
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextFormField(
                controller: _controller,
                textAlign: TextAlign.left,
                autovalidateMode: AutovalidateMode.always,
                decoration: InputDecoration(
                  contentPadding:
                      MediaQuery.of(context).size.width < mobileWidth
                          ? const EdgeInsets.only(top: -15.0)
                          : const EdgeInsets.only(top: 0.0),
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
                          ? IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              onPressed: () => submitQuery(_controller.text),
                              icon: const Icon(Icons.search))
                          : const Icon(Icons.search),
                    ),
                  ),
                  hintText: myChildSize == Size.zero
                      ? 'Search for a song...'
                      : myChildSize.width > mobileWidth
                          ? 'Search for a song... or piece... or artist...'
                          : 'Search for a song...',
                  hintStyle: Theme.of(context).textTheme.labelSmall,
                ),
                onChanged: (String? value) {
                  (value == null || value.isEmpty)
                      ? setState(() {
                          isSearchButtonDisabled = true;
                        })
                      : setState(() {
                          isSearchButtonDisabled = false;
                        });
                },
                onFieldSubmitted: (String? value) {
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
            )),
      ),
    );
  }

  // function that opens a new page on submit query
  void submitQuery(String query) {
    // !submit query
    if (query.isNotEmpty && query != '') {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => SearchResults(query: query),
      //   ),
      // );
    }
    print(_controller.text);
  }
}
