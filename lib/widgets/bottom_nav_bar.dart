import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'icon_badge.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  PageController _pageController;
  int _page = 1;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.book),
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
            // size: 25,
          ),
          title: Container(),
        ),
      ],
      onTap: navigationTapped,
      currentIndex: _page,
    );
  }
}
