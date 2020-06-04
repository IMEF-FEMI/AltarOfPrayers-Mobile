import 'package:altar_of_prayers/models/user.dart';
import 'package:altar_of_prayers/widgets/icon_badge.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'home.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, @required this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[
            Container(
              child: Center(
                child: Text('Today'),
              ),
            ),
            Home(user: widget.user),
            Container(
              child: Center(
                child: Text('About'),
              ),
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
                    FontAwesomeIcons.book
                  ),
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
            )));
  
  }
}
