import 'package:altar_of_prayers/blocs/app_config/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

 /**
  *  Scaffold widget to be reused within the app

 */
class AppScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final IconButton leading;
  final Widget bottomNav;
  final Widget saveButton;

  const AppScaffold({
    Key key,
    @required this.body,
    @required this.title,
    this.leading,
    this.bottomNav,
    this.saveButton,
  }) : super(key: key);

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  _leadingWidget() {
    if (widget.leading != null) return widget.leading;
    return;
  }

  _bottomNav() {
    if (widget.bottomNav != null) return widget.bottomNav;
    return;
  }

  _toggleDarkMode() =>
      ConfigBloc().add(DarkModeEvent(!ConfigBloc().darkModeOn));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        bottomNavigationBar: _bottomNav(),
        appBar: AppBar(
          leading: _leadingWidget(),
          title: GestureDetector(
            onTap: _toggleDarkMode,
            child: Text(
              widget.title,
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            if (widget.saveButton == null)
              IconButton(
                icon: Icon(
                  ConfigBloc().darkModeOn
                      ? FontAwesomeIcons.toggleOn
                      : FontAwesomeIcons.toggleOff,
                  size: 18,
                ),
                onPressed: _toggleDarkMode,
              ),
            if (widget.saveButton != null) widget.saveButton,
          ],
        ),
        body: widget.body,
      ),
    );
  }
}
