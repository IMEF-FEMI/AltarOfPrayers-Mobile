import 'dart:math';

import 'package:altar_of_prayers/models/notification.dart';
import 'package:altar_of_prayers/utils/tools.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationDetail extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetail({Key key, this.notification}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Notification",
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Icon(FontAwesomeIcons.bell,
                    size: 200, color: Tools.multiColors[Random().nextInt(4)]),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                notification.title,
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  notification.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
