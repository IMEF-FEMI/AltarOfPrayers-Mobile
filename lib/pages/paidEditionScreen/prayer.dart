import 'package:altar_of_prayers/blocs/make_payment/bloc.dart';
import 'package:altar_of_prayers/blocs/prayer/bloc.dart';
import 'package:altar_of_prayers/pages/make_payment_screen.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:altar_of_prayers/widgets/error_screen.dart';
import 'package:altar_of_prayers/widgets/loading_widget.dart';
import 'package:altar_of_prayers/widgets/not_available.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:intl/intl.dart';

class Prayer extends StatefulWidget {
  final int year;
  final int month;
  final int day;
  final bool disableClose;

  const Prayer(
      {Key key, this.year, this.month, this.day, this.disableClose = false})
      : super(key: key);

  @override
  _PrayerState createState() => _PrayerState();
}

class _PrayerState extends State<Prayer> {
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
    return AppScaffold(
      title: '${DateFormat('MMMMEEEEd').format(DateTime.now().toUtc())}',
      leading: buildLeadingIcon(widget.disableClose),
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
          },
          child:
              BlocBuilder<PrayerBloc, PrayerState>(builder: (context, state) {
            if (state is PrayerLoaded)
              return Center(
                  child: Text(
                      'Today: ${widget.day} / ${widget.month} / ${widget.year}'));
            if (state is ShowMakePaymentScreen)
              return MakePaymentScreen(
                edition: state.edition,
                makePaymentBloc: _makePaymentBloc,
              );

            if (state is PrayerNotAvailable)
              return NotAvailable(
                message: 'Not available',
              );
            if (state is PrayerError)
              return ErrorScreen(
                errorMessage: state.error,
                btnOnPressed: () => _prayerBloc.add(LoadPrayer(
                    year: widget.year, month: widget.month, day: widget.day)),
              );
            return LoadingWidget();
          }),
        ),
      ),
    );
  }

  IconButton buildLeadingIcon(bool disableClose) {
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
        saved ? FontAwesomeIcons.solidBookmark : FontAwesomeIcons.bookmark,
        color: Colors.blue,
      ),
      onPressed: () {
        setState(() {
          saved = !saved;
        });
      },
    );
  }
}
