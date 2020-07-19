import 'package:altar_of_prayers/blocs/app_config/config_bloc.dart';
import 'package:altar_of_prayers/blocs/make_payment/bloc.dart';
import 'package:altar_of_prayers/blocs/prayer/bloc.dart';
import 'package:altar_of_prayers/pages/make_payment/make_payment_screen.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:altar_of_prayers/widgets/error_screen.dart';
import 'package:altar_of_prayers/widgets/loading_widget.dart';
import 'package:altar_of_prayers/widgets/not_available.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:intl/intl.dart';

class PrayerScreen extends StatefulWidget {
  final int year;
  final int month;
  final int day;
  final bool disableClose;

  const PrayerScreen(
      {Key key, this.year, this.month, this.day, this.disableClose = false})
      : super(key: key);

  @override
  _PrayerState createState() => _PrayerState();
}

class _PrayerState extends State<PrayerScreen> {
  PrayerBloc _prayerBloc;
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  MakePaymentBloc _makePaymentBloc;
  bool saved = false;

  @override
  void initState() {
    super.initState();
    _makePaymentBloc = MakePaymentBloc();
    _prayerBloc = PrayerBloc(makePaymentBloc: _makePaymentBloc);
  }

  @override
  void dispose() {
    super.dispose();
    _makePaymentBloc.close();
    _prayerBloc.close();
  }

  Future<Null> loadPrayer() async {
    _prayerBloc.add(LoadPrayer(
        year: widget.year,
        month: widget.month,
        day: widget.day,
        showDialog: false));
    await Future.delayed(Duration(seconds: 2));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<PrayerBloc>(
        create: (context) => _prayerBloc
          ..add(LoadPrayer(
              year: widget.year,
              month: widget.month,
              day: widget.day,
              showDialog: false)),
        child: BlocListener<PrayerBloc, PrayerState>(
          listener: (context, state) {
            if (state is PrayerLoaded && state.showDialog)
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AssetGiffyDialog(
                  image: Image.asset(
                    'assets/images/success.gif',
                    fit: BoxFit.fitWidth,
                  ),
                  title: Text(
                    'Congrats! Payment Successful',
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
                  ),
                  onOkButtonPressed: () {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pop(true);
                  },
                  onlyOkButton: true,
                ),
              );
            if (state is PrayerLoaded && state.saved == true)
              setState(() {
                saved = true;
              });
            if (state is PrayerLoaded && state.saved == false)
              setState(() {
                saved = false;
              });
          },
          child:
              BlocBuilder<PrayerBloc, PrayerState>(builder: (context, state) {
            return AppScaffold(
              title:
                  '${DateFormat('MMMMEEEEd').format(DateTime(widget.year, widget.month, widget.day))}',
              leading: _buildLeadingIcon(context, widget.disableClose, state),
              body: _prayerBody(state),
            );
          }),
        ),
      ),
    );
  }

  Widget _prayerBody(PrayerState state) {
    if (state is PrayerLoaded)
      return SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30.0, right: 25.0, top: 18.0, bottom: 18.0),
                  child: Text(
                    state.prayer.topic,
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.w400,
                          fontFamily: "Georgia",
                          color: ConfigBloc().darkModeOn
                              ? Colors.white
                              : Colors.black,
                        ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color:
                      ConfigBloc().darkModeOn ? Colors.grey : Colors.grey[300]),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Text(
                            "Bible Reading",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            state.prayer.passage,
                            softWrap: true,
                            textAlign: TextAlign.justify,
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: ConfigBloc().darkModeOn
                      ? Colors.blueGrey
                      : Colors.blueGrey[100]),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 5,
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            state.prayer.message,
                            softWrap: true,
                            textAlign: TextAlign.justify,
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      fontWeight: FontWeight.w200,
                                      // letterSpacing: 1.5,
                                      fontSize: 18,
                                      // wordSpacing: 1.5,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Text(
                            "Prayer Points",
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.prayer.prayerPoints.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${index + 1}. " +
                                      state.prayer.prayerPoints[index],
                                  softWrap: true,
                                  textAlign: TextAlign.justify,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                        // letterSpacing: 1.5,
                                        // wordSpacing: 1.5,
                                        fontSize: 18,
                                      ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            );
                          },
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    if (state is ShowMakePaymentScreen)
      return MakePaymentScreen(
        edition: state.edition,
        makePaymentBloc: _makePaymentBloc,
      );

    if (state is PrayerNotAvailable)
      return NotAvailable(
        message: 'Edition Not available',
      );
    if (state is PrayerError)
      return ErrorScreen(
        errorMessage: state.error,
        btnOnPressed: () => _prayerBloc.add(LoadPrayer(
            year: widget.year, month: widget.month, day: widget.day)),
      );
    return LoadingWidget();
  }

  IconButton _buildLeadingIcon(
      BuildContext context, bool disableClose, PrayerState state) {
    if (!widget.disableClose)
      return IconButton(
        icon: Icon(
          Icons.close,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    return IconButton(
      icon: Icon(
          saved ? FontAwesomeIcons.solidBookmark : FontAwesomeIcons.bookmark),
      onPressed: () {
        if (state is PrayerLoaded) {
          if (saved) {
            _prayerBloc.add(UnsavePrayer(prayer: state.prayer));
            setState(() {
              saved = false;
            });
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.fixed,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Removed',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      )),
                      Icon(FontAwesomeIcons.bookmark, color: Colors.white),
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          } else {
            _prayerBloc.add(SavePrayer(prayer: state.prayer));
            setState(() {
              saved = true;
            });
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.fixed,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Saved',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      )),
                      Icon(FontAwesomeIcons.solidBookmark, color: Colors.white),
                    ],
                  ),
                  backgroundColor: Colors.green,
                ),
              );
          }
        }
      },
    );
  }
}
