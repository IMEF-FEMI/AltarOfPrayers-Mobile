import 'package:altar_of_prayers/blocs/authentication/bloc.dart';
import 'package:altar_of_prayers/models/edition.dart';
import 'package:altar_of_prayers/models/user.dart';
import 'package:altar_of_prayers/utils/tools.dart';
import 'package:altar_of_prayers/widgets/mainEditionCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    print(daysInMonth(DateTime.utc(year, month, 01)));
    final DateTime picked = await showDatePicker(
      context: context,
      useRootNavigator: false,
      initialDate: DateTime.utc(year, month, 01),
      firstDate: DateTime.utc(year, month, 01),
      lastDate: DateTime.utc(year, month, 01)
          .add(Duration(days: daysInMonth(DateTime.utc(year, month, 01)) - 1)),
    );
    
    if (picked != null) print('picked: ${picked.day}');
  }

  @override
  Widget build(BuildContext context) {
    User user =
        (BlocProvider.of<AuthenticationBloc>(context).state as Authenticated)
            .user;

    return SingleChildScrollView(
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
                style: Theme.of(context).textTheme.title.copyWith(
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
                        style: Theme.of(context).textTheme.subtitle),
                    Text(
                        '${widget.edition.paidBy['fullname']} \n (${widget.edition.paidBy['email']})',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle),
                  ],
                ),
              SizedBox(
                height: 20,
              ),
              MainEditionCard(
                  month:
                      '${Tools.monthString[widget.edition.startingMonth - 1]}',
                  icon: FontAwesomeIcons.calendarAlt,
                  onPressed: () => _selectDate(context, widget.edition.year,
                      widget.edition.startingMonth)),
              SizedBox(
                height: 20,
              ),
              MainEditionCard(
                month: '${Tools.monthString[widget.edition.startingMonth]}',
                icon: FontAwesomeIcons.calendarAlt,
                onPressed: () => _selectDate(context, widget.edition.year,
                    widget.edition.startingMonth + 1),
              ),
              SizedBox(
                height: 20,
              ),
              MainEditionCard(
                month: '${Tools.monthString[widget.edition.startingMonth + 1]}',
                icon: FontAwesomeIcons.calendarAlt,
                onPressed: () => _selectDate(context, widget.edition.year,
                    widget.edition.startingMonth + 2),
              ),
              SizedBox(
                height: 20,
              ),
              MainEditionCard(
                month: 'Gift A Copy ',
                icon: FontAwesomeIcons.gift,
                onPressed: () {},
              ),
              SizedBox(
                height: 20,
              ),
              MainEditionCard(
                month: 'Copies Gifted',
                icon: FontAwesomeIcons.gifts,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
