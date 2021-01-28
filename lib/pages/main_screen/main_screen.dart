import 'package:altar_of_prayers/blocs/main_screen/bloc.dart';
import 'package:altar_of_prayers/blocs/notificaions/bloc.dart';
import 'package:altar_of_prayers/models/user.dart';
import 'package:altar_of_prayers/pages/about/about_page.dart';
import 'package:altar_of_prayers/pages/notifications/notifications.dart';
import 'package:altar_of_prayers/pages/paidEditionScreen/prayer.dart';
import 'package:altar_of_prayers/widgets/custom_nav.dart';
import 'package:altar_of_prayers/widgets/icon_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'home.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, @required this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  DateTime today = DateTime.now().toUtc();
  NotificationsBloc _notificationsBloc;

  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  @override
  void initState() {
    super.initState();
    _notificationsBloc = NotificationsBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _notificationsBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainScreenBloc>(
      create: (context) =>
          MainScreenBloc(notificationsBloc: _notificationsBloc),
      child: BlocBuilder<MainScreenBloc, MainScreenState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              final isFirstRouteInCurrentTab =
                  !await _navigatorKeys[_currentIndex].currentState.maybePop();

              if (isFirstRouteInCurrentTab) {
                // if not on the 'main' tab
                if (_currentIndex != 0) {
                  // select 'main' tab
                  setState(() {
                    _currentIndex = 0;
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
                    child: Home(),
                    navigatorkey: _navigatorKeys[0],
                  ),
                  CustomNav(
                    child: PrayerScreen(
                        year: today.year,
                        month: today.month,
                        day: today.day,
                        disableClose: true),
                    navigatorkey: _navigatorKeys[1],
                  ),
                  CustomNav(
                    child: Notifications(
                      notificationsBloc: _notificationsBloc,
                    ),
                    navigatorkey: _navigatorKeys[2],
                  ),
                  CustomNav(
                    child: AboutPage(),
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
                      icon: Icon(
                        FontAwesomeIcons.home,
                      ),
                      title: Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Home",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FontAwesomeIcons.calendarAlt, size: 25),
                      title: Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Today",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    BottomNavigationBarItem(
                      icon: IconBadge(
                        icon: FontAwesomeIcons.solidBell,
                        badgeCount: (state as MainScreenInitial).badgeCount,
                      ),
                      title: Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Notifications",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        FontAwesomeIcons.infoCircle,
                      ),
                      title: Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "About",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
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
        },
      ),
    );
  }
}
