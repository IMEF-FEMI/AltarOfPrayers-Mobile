import 'package:altar_of_prayers/blocs/authentication/bloc.dart';
import 'package:altar_of_prayers/models/edition.dart';
import 'package:altar_of_prayers/models/user.dart';
import 'package:altar_of_prayers/pages/gift_copy/gift_copy_screen.dart';
import 'package:altar_of_prayers/utils/tools.dart';
import 'package:altar_of_prayers/widgets/mainEditionCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'prayer.dart';

class MainEditionScreen extends StatefulWidget {
  final Edition edition;

  const MainEditionScreen({Key key, this.edition}) : super(key: key);

  @override
  _MainEditionScreenState createState() => _MainEditionScreenState();
}

class _MainEditionScreenState extends State<MainEditionScreen> {
  int daysInMonth(DateTime date) {
    // var firstDayThisMonth = new DateTime(date.year, date.month, date.day);
    // var firstDayNextMonth = new DateTime(firstDayThisMonth.year, firstDayThisMonth.month + 1, firstDayThisMonth.day);
    // return firstDayNextMonth.difference(firstDayThisMonth).inDays;

    DateTime x1 = DateTime(date.year, date.month, date.day).toUtc();
    var y1 = DateTime(date.year, date.month + 1, date.day)
        .toUtc()
        .difference(x1)
        .inDays;
    return y1;
  }

  Future<Null> _selectDate(BuildContext context, int year, int month) async {
    final DateTime picked = await showDatePicker(
      context: context,
      useRootNavigator: false,
      initialDate: DateTime.utc(year, month, 01),
      firstDate: DateTime.utc(year, month, 01),
      lastDate: DateTime.utc(year, month, 01)
          .add(Duration(days: daysInMonth(DateTime.utc(year, month, 01)) - 1)),
    );

    if (picked != null)
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PrayerScreen(
                year: picked.year,
                month: picked.month,
                day: picked.day,
                disableClose: true,
              )));
  }

  @override
  Widget build(BuildContext context) {
    User user =
        (BlocProvider.of<AuthenticationBloc>(context).state as Authenticated)
            .user;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(
              30,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.edition.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (user.email != widget.edition.paidBy['email'])
                  Column(
                    children: <Widget>[
                      Text('Gifted to you by ',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle2),
                      Text(
                          '${widget.edition.paidBy['fullname']} \n (${widget.edition.paidBy['email']})',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle2),
                    ],
                  ),
                SizedBox(
                  height: 20,
                ),
                MainEditionCard(
                    month:
                        '${Tools.monthString[widget.edition.startingMonth - 1]}',
                    icon: Icon(
                      FontAwesomeIcons.calendarAlt,
                      size: 40,
                      color: Colors.cyan,
                    ),
                    onPressed: () => _selectDate(context, widget.edition.year,
                        widget.edition.startingMonth)),
                SizedBox(
                  height: 20,
                ),
                MainEditionCard(
                  month: '${Tools.monthString[widget.edition.startingMonth]}',
                  icon: Icon(
                    FontAwesomeIcons.calendarAlt,
                    size: 40,
                    color: Colors.cyan,
                  ),
                  onPressed: () => _selectDate(context, widget.edition.year,
                      widget.edition.startingMonth + 1),
                ),
                SizedBox(
                  height: 20,
                ),
                MainEditionCard(
                  month:
                      '${Tools.monthString[widget.edition.startingMonth + 1]}',
                  icon: Icon(
                      FontAwesomeIcons.calendarAlt,
                      size: 40,
                      color: Colors.cyan,
                    ),
                  onPressed: () => _selectDate(context, widget.edition.year,
                      widget.edition.startingMonth + 2),
                ),
                SizedBox(
                  height: 20,
                ),
                MainEditionCard(
                  month: 'Gift A Copy ',
                   icon: Icon(
                      FontAwesomeIcons.gift,
                      size: 40,
                      color: Colors.cyan,
                    ),
                  onPressed: () {
                    showBottomSheet(
                        context: context,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        builder: ((BuildContext contex) {
                          return Container(
                              height: MediaQuery.of(context).size.height * .8,
                              width: MediaQuery.of(context).size.width,
                              // color: Colors.amber,
                              child: GiftCopyScreen(
                                editionId: widget.edition.id,
                              ));
                        }));
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                MainEditionCard(
                  month: 'Copies Gifted',
                  icon: Icon(
                      FontAwesomeIcons.gifts,
                      size: 40,
                      color: Colors.cyan,
                    ),
                  onPressed: () {
                    if (widget.edition.copiesGifted.length == 0)
                      showModalBottomSheet(
                          // showBottomSheet(
                          context: context,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18))),
                          builder: ((BuildContext contex) {
                            return Container(
                                height: MediaQuery.of(context).size.height * .9,
                                width: MediaQuery.of(context).size.width,
                                // color: Colors.amber,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        FontAwesomeIcons.gift,
                                        size: 100,
                                        color: Colors.pink,
                                      ),
                                      SizedBox(height: 30),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          "You have not gifted any copy yet",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ));
                          }));
                    if (widget.edition.copiesGifted.length > 0)
                      showModalBottomSheet(
                          // showBottomSheet(
                          context: context,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          builder: ((BuildContext contex) {
                            return Container(
                                height: MediaQuery.of(context).size.height * .9,
                                width: MediaQuery.of(context).size.width,
                                // color: Colors.amber,
                                child: Center(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        widget.edition.copiesGifted.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: <Widget>[
                                          Text(
                                            widget.edition.copiesGifted[index]
                                                ["paidFor"]["fullname"],
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                          Text(
                                            widget.edition.copiesGifted[index]
                                                ["paidFor"]["email"],
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),
                                          Text(
                                            DateFormat('yMMMMd').format(
                                              DateTime.parse(widget.edition
                                                      .copiesGifted[index]
                                                  ["paidFor"]["createdAt"]),
                                            ),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ));
                          }));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
