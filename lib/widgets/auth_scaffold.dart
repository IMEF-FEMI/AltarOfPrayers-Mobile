import 'package:altar_of_prayers/config/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final VoidCallback logout;

  const AuthScaffold(
      {Key key, @required this.body, @required this.title, this.logout})
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
                      ? FontAwesomeIcons.lightbulb
                      : FontAwesomeIcons.solidLightbulb,
                  size: 18,
                ),
                onPressed: () {
                  ConfigBloc().add(DarkModeEvent(!ConfigBloc().darkModeOn));
                },
              ),
              if (logout != null)
                IconButton(
                  onPressed: logout,
                  icon: Icon(
                    FontAwesomeIcons.signOutAlt,
                    size: 20,
                  ),
                ),
            ],
          ),
          body: body,
        ),
      ),
    );
  }
}
