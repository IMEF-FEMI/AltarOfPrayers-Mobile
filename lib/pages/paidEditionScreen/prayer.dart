import 'package:altar_of_prayers/blocs/make_payment/bloc.dart';
import 'package:altar_of_prayers/blocs/prayer/bloc.dart';
import 'package:altar_of_prayers/pages/make_payment_screen.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:altar_of_prayers/widgets/error_screen.dart';
import 'package:altar_of_prayers/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '${widget.day}/${widget.month}/${widget.year}',
      leading: buildLeadingIcon(widget.disableClose),
      body: BlocProvider<PrayerBloc>(
        create: (context) =>
            _prayerBloc..add(LoadPrayer(widget.year, widget.month, widget.day)),
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
                    'Congrats!',
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
                  ),
                  description: Text(
                    'Payment has been successfully made',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
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
                      'Today: ${widget.day}/${widget.month}/${widget.year}'));
            if (state is ShowMakePaymentScreen)
              return MakePaymentScreen(
                edition: state.edition,
                makePaymentBloc: _makePaymentBloc,
              );

            if (state is PrayerNotAvailable)
              return Center(
                child: Text('Edition Not Available'),
              );
            if (state is PrayerError)
              return ErrorScreen(
                errorMessage: state.error,
                btnOnPressed: () => _prayerBloc
                    .add(LoadPrayer(widget.year, widget.month, widget.day)),
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
