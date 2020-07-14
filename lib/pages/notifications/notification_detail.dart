import 'package:altar_of_prayers/models/notification.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Icon(FontAwesomeIcons.bell, size: 200,),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
