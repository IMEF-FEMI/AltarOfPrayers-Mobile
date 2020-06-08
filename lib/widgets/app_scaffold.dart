import 'package:altar_of_prayers/pages/config/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppScaffold extends StatefulWidget {
  final String title;
  final Widget body;


  const AppScaffold(
      {Key key, @required this.body, @required this.title,})
      : super(key: key);

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
              // setState(() {
                
              // });
              ConfigBloc().add(DarkModeEvent(!ConfigBloc().darkModeOn));
            },
          ),
        ],
      ),
      body: widget.body,
    );
  }
}
