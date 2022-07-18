import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DefaultLower extends StatefulWidget {
  final bool isLogo;
  const DefaultLower({Key? key, required this.isLogo}) : super(key: key);

  @override
  State<DefaultLower> createState() => _DefaultLower();
}

class _DefaultLower extends State<DefaultLower> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: widget.isLogo == true
                ? const FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'Reclaim your music taste',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                    ),
                  )
                : const SizedBox.shrink()),
        const Divider(
          color: Color.fromARGB(255, 255, 255, 255),
          height: 1,
          thickness: 2,
          indent: 35,
          endIndent: 35,
        ),
        Container(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6.0, top: 6.0, left: 25),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.bottomLeft,
              child: TextButton.icon(
                icon: const Icon(
                  Icons.bug_report_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  'Report a bug',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                onPressed: () async {
                  const toEmail = 'tunescape2022@uofthatchery.ca';
                  const subject = 'Bug Report';
                  const body = 'Please describe the bug you encountered.';
                  Uri url = Uri.parse(
                      'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}');

                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
