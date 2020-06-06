import 'package:altar_of_prayers/pages/config/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;


  const AppScaffold(
      {Key key, @required this.body, @required this.title,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              ConfigBloc().darkModeOn
                ? FontAwesomeIcons.toggleOn
                : FontAwesomeIcons.toggleOff,
              size: 18,
            ),
            onPressed: () {
              ConfigBloc().add(DarkModeEvent(!ConfigBloc().darkModeOn));
            },
          ),
        ],
      ),
      body: body,
    );
  }
}
