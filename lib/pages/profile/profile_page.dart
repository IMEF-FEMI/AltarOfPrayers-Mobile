import 'dart:math';

import 'package:altar_of_prayers/blocs/authentication/bloc.dart';
import 'package:altar_of_prayers/models/user.dart';
import 'package:altar_of_prayers/utils/tools.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:altar_of_prayers/widgets/mainEditionCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:altar_of_prayers/widgets/notification_plugin.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    notificationPlugin
        .setListenerForLowerFunctions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {}
  onNotificationClick() {}
  
  @override
  Widget build(BuildContext context) {
    User user =
        (BlocProvider.of<AuthenticationBloc>(context).state as Authenticated)
            .user;

    return AppScaffold(
      title: "Altar of Prayers",
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Icon(FontAwesomeIcons.userShield,
                    size: 100, color: Tools.multiColors[Random().nextInt(4)]),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Full Name:",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                user.fullName,
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Email: ",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                user.email,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Registered: ",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                '${DateFormat('yMMMMd').format(DateTime.parse(user.createdAt))}',
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 80.0,
                ),
                child: MainEditionCard(
                  month: 'Logout',
                  icon: Icon(
                    FontAwesomeIcons.signOutAlt,
                    size: 30,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    // BlocProvider.of<AuthenticationBloc>(context)
                    //     .add(LoggedOut());
                    notificationPlugin.showNotification();

                    // notificationPlugin.showNotification();
                  },
                  height: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
