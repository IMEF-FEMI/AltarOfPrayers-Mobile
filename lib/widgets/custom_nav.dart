import 'package:flutter/material.dart';
class CustomNav extends StatefulWidget {
  const CustomNav({ Key key, this.child, this.navigatorkey }) : super(key: key);

  final Widget child;
  final GlobalKey<NavigatorState> navigatorkey;

  @override
  _CustomNavState createState() => _CustomNavState();
}

class _CustomNavState extends State<CustomNav> {

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorkey,
      
      onGenerateRoute: (RouteSettings settings) {
        return new MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return widget.child;
          },
        );
      },
    );
  }
}
