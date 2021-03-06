import 'package:altar_of_prayers/models/user.dart';
import 'package:altar_of_prayers/pages/NewEditions/new_editions_page.dart';
import 'package:altar_of_prayers/pages/myEditions/my_edition_page.dart';
import 'package:altar_of_prayers/pages/profile/profile_page.dart';
import 'package:altar_of_prayers/pages/prophetic_prayers/prophetic_prayers.dart';
import 'package:altar_of_prayers/pages/reminder/reminder_page.dart';
import 'package:altar_of_prayers/pages/savedPrayers/savedPrayers.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:altar_of_prayers/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatelessWidget {
  final User user;

  const Home({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Altar Of Prayers',
      body: Column(
        children: <Widget>[
          Expanded(
              child: GridView.count(
            childAspectRatio: .85,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            crossAxisCount: 2,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            children: <Widget>[
              CategoryCard(
                  title: 'Saved Prayers Points',
                  desctiption: 'View Prayer Points you have recently saved',
                  color: Colors.blue,
                  icon: FontAwesomeIcons.solidBookmark,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SavedPrayersScreen()))),
              CategoryCard(
                  title: 'New Editions',
                  desctiption: 'Check for new Edition',
                  color: Colors.teal,
                  icon: FontAwesomeIcons.cartArrowDown,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NewEditionsPage()))),
              CategoryCard(
                  title: 'My Editions',
                  desctiption: 'All Editions you have Subscribed for',
                  color: Colors.cyan,
                  icon: FontAwesomeIcons.bookOpen,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MyEditionsPage()))),
              CategoryCard(
                  title: 'Prophetic Prayers',
                  desctiption: 'Daily Prophetic Prayers from the Altar of Prayers ',
                  color: Colors.red,
                  icon: FontAwesomeIcons.shieldAlt,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PropheticPrayers()))),
              CategoryCard(
                  title: 'My Profile',
                  desctiption: 'Informations about your account ',
                  color: Colors.pink,
                  icon: FontAwesomeIcons.userAlt,
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProfilePage()))),
                           CategoryCard(
                  title: 'Reminder',
                  desctiption: 'Set Daily Prayer Reminder',
                  color: Colors.purple,
                  icon: FontAwesomeIcons.solidBell,
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ReminderPage()))),
            ],
          ))
        ],
      ),
    );
  }
}
