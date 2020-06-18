import 'dart:math';

import 'package:altar_of_prayers/pages/NewEditions/new_edition_page.dart';
import 'package:altar_of_prayers/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditionCard extends StatelessWidget {
  final edition;

  EditionCard({
    Key key,
    this.edition,
  }) : super(key: key);

  final months = {
    1: 'Jan - March',
    4: 'Apr - June',
    7: 'July - Sept',
    10: 'Oct - Dec',
  };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => NewEditionPage(edition: edition)));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
                child: Hero(
                  tag: edition['name'],
                  child: SvgPicture.asset(
                    'assets/icons/bible.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        edition['name'],
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 14),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 5,
                        color: edition['paid'] == true
                            ? Tools.multiColors[3]
                            : Tools.multiColors[0],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    months[int.parse('${edition['startingMonth']}')] +
                        ' ( New )',
                    style: Theme.of(context).textTheme.subtitle.copyWith(
                        color: edition['paid'] == false
                            ? Tools.multiColors[0]
                            : null),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${edition['year']}',
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
