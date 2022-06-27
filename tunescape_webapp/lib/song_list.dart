import 'package:flutter/material.dart';

class SongListDrawer extends StatefulWidget {
  const SongListDrawer({Key? key}) : super(key: key);

  @override
  State<SongListDrawer> createState() => _SongListDrawer();
}

class _SongListDrawer extends State<SongListDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: 400,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Expanded(
              child: ListView.builder(
                  itemCount: 4, //!
                  itemBuilder: (context, index) {
                    return Container(
                      height: 60,
                    );
                  }),
            ),
          ],
        ));
  }
}
