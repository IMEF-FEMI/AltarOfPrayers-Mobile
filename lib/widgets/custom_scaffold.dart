import 'package:altar_of_prayers/pages/config/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const CustomScaffold(
      {Key key, @required this.body, @required this.title,})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      color: ConfigBloc().darkModeOn ? Colors.grey[800] : Colors.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
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
        ),
      ),
    );
  }
}
