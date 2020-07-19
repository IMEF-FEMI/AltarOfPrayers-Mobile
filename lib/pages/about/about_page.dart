import 'package:altar_of_prayers/utils/altarofprayers.dart';
import 'package:altar_of_prayers/utils/tools.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:altar_of_prayers/widgets/image_card.dart';
import 'package:flutter/material.dart';

import 'developer_card.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Altar of Prayers",
      body: ListView(
        children: <Widget>[
          ImageCard(
            img: AltarOfPrayers.banner_light,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              Tools().aboutText,
              textAlign: TextAlign.justify,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    fontFamily: "Georgia",
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Contact Us",
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Georgia",
                  fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              Tools().contactText,
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  // fontWeight: FontWeight.bold,
                  fontFamily: "Georgia",
                  fontSize: 18),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Developer",
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Georgia",
                  fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),

          DeveloperCard()
        ],
      ),
    );
  }
}
