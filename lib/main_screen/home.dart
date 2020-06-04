import 'package:altar_of_prayers/models/user.dart';
import 'package:altar_of_prayers/widgets/category_card.dart';
import 'package:altar_of_prayers/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatelessWidget {
  final User user;

  const Home({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
  
    return CustomScaffold(
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
                title: 'Saved Prayers',
                desctiption: 'All the Prayer points you have saved recently ',
                color: Colors.blue,
                icon: FontAwesomeIcons.bookmark,
              ),
              CategoryCard(
                title: 'Prophetic Prayers',
                desctiption: 'Prophetic Prayers from the Altar of Prayers ',
                color: Colors.deepOrange,
                icon: FontAwesomeIcons.shieldAlt,
              ),
              CategoryCard(
                title: 'New Editions',
                desctiption:
                    'Check to see if new a new Edition has been published',
                color: Colors.teal,
                icon: FontAwesomeIcons.book,
              ),
              CategoryCard(
                title: 'My Editions',
                desctiption: 'All Editions you have Subscribed for',
                color: Colors.cyan,
                icon: FontAwesomeIcons.cartArrowDown,
              ),
              CategoryCard(
                title: 'My Profile',
                desctiption: 'Informations about your account ',
                color: Colors.green,
                icon: FontAwesomeIcons.user,
              ),
            ],
          ))
        ],
      ),
    );
  }
}
