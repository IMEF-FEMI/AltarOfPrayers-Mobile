import 'package:altar_of_prayers/models/user.dart';
import 'package:altar_of_prayers/pages/main_screen/about.dart';
import 'package:altar_of_prayers/pages/paidEditionScreen/prayer.dart';
import 'package:altar_of_prayers/widgets/custom_nav.dart';
import 'package:altar_of_prayers/widgets/icon_badge.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'home.dart';
import 'notifications.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, @required this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  DateTime today = DateTime.now().toUtc();
  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentIndex].currentState.maybePop();

        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_currentIndex != 1) {
            // select 'main' tab
            setState(() {
              _currentIndex = 1;
            });
            // back button handled by app
            return false;
          }
          return true;
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: <Widget>[
            CustomNav(
              child:
                  Prayer(year: today.year, month: today.month, day: today.day, disableClose:true),
              navigatorkey: _navigatorKeys[0],
            ),
            CustomNav(
              child: Home(),
              navigatorkey: _navigatorKeys[1],
            ),
            CustomNav(
              child: Notifications(),
              navigatorkey: _navigatorKeys[2],
            ),
            CustomNav(
              child: About(),
              navigatorkey: _navigatorKeys[3],
            ),
          ],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Theme.of(context).primaryColor,
            // active color
            // primaryColor: Color(0xFF28a745),
            primaryColor: Theme.of(context).accentColor,
            textTheme: Theme.of(context).textTheme.copyWith(
                  caption: TextStyle(color: Colors.grey[500]),
                ),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.calendarAlt),
                title: Container(),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.home,
                ),
                title: Container(),
              ),
              BottomNavigationBarItem(
                icon: IconBadge(
                  icon: FontAwesomeIcons.solidBell,
                ),
                title: Container(),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.infoCircle,
                ),
                title: Container(),
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            currentIndex: _currentIndex,
          ),
        ),
      ),
    );
  }
}
