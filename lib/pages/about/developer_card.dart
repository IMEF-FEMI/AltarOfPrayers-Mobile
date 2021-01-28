import 'dart:math';

import 'package:altar_of_prayers/utils/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperCard extends StatelessWidget {
  final Uri _emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'bolajifemi28@gmail.com',
  );
  Widget socialButtons() => FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.twitter,
                size: 15,
              ),
              onPressed: () {
                launch("https://twitter.com/dev_femi");
              },
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.linkedinIn,
                size: 15,
              ),
              onPressed: () {
                launch("https://www.linkedin.com/in/femi-bolaji-3086811a3/");
              },
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.github,
                size: 15,
              ),
              onPressed: () {
                launch("https://github.com/imef-femi");
              },
            ),
             IconButton(
              icon: Icon(
                FontAwesomeIcons.envelope,
                size: 15,
              ),
              onPressed: () {
                launch(_emailLaunchUri.toString());
              },
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
                child: Image.asset(
                  "assets/images/dev_femi.png",
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Femi Bolaji",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        AnimatedContainer(
                          duration: Duration(seconds: 1),
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: 5,
                          color: Tools.multiColors[Random().nextInt(4)],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Software Developer",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Flutter | Django | React",
                      style: Theme.of(context).textTheme.caption,
                    ),
                    socialButtons(),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
