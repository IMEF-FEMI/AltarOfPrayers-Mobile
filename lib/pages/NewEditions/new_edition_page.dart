import 'package:altar_of_prayers/blocs/app_config/index.dart';
import 'package:altar_of_prayers/blocs/edition/bloc.dart';
import 'package:altar_of_prayers/blocs/make_payment/bloc.dart';
import 'package:altar_of_prayers/pages/make_payment_screen.dart';
import 'package:altar_of_prayers/pages/paidEditionScreen/edition.dart';
import 'package:altar_of_prayers/repositories/edition_repository.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:altar_of_prayers/widgets/error_screen.dart';
import 'package:altar_of_prayers/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class NewEditionPage extends StatefulWidget {
  final edition;

  const NewEditionPage({Key key, this.edition}) : super(key: key);

  @override
  NewEditionPageState createState() => NewEditionPageState();
}

class NewEditionPageState extends State<NewEditionPage> {
  EditionBloc _editionBloc;
  MakePaymentBloc _makePaymentBloc;
  EditionsRepository _editionsRepository = EditionsRepository();

  threeSidedBorderRadius({double radius = 8}) {
    return BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
        bottomRight: Radius.circular(radius));
  }

  @override
  void initState() {
    super.initState();
    _makePaymentBloc = MakePaymentBloc();
    _editionBloc = EditionBloc(
        editionsRepository: _editionsRepository,
        makePaymentBloc: _makePaymentBloc);
  }

  @override
  void dispose() {
    super.dispose();
    _editionBloc.close();
    _makePaymentBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditionBloc>(
      create: (context) => _editionBloc
        ..add(LoadEdition(edition: widget.edition, showDialog: false)),
      child: AppScaffold(
        title: '',
        leading: IconButton(
          icon: Icon(
            Icons.close,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottomNav: Container(
          height: MediaQuery.of(context).size.height * .15,
          // color: Colors.black12,
          child: Column(
            children: <Widget>[
              Divider(
                color: ConfigBloc().darkModeOn ? Colors.grey : Colors.blue[100],
                thickness: 1.5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  borderRadius: threeSidedBorderRadius(),
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 100),
                    child: Text(
                      "Close",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: threeSidedBorderRadius(),
                      border: Border.all(
                          color: Theme.of(context).accentColor, width: 1.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: BlocListener<EditionBloc, EditionState>(
          listener: (context, state) async {
            if (state is EditionLoaded && state.showDialog) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => WillPopScope(
                  onWillPop: () async {
                    return false;
                  },
                  child: AssetGiffyDialog(
                    image: Image.asset(
                      'assets/images/success.gif',
                      fit: BoxFit.fitWidth,
                    ),
                    title: Text(
                      'Congrats! Payment Successful',
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.w500),
                    ),
                    onOkButtonPressed: () {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pop(true);
                    },
                    onlyOkButton: true,
                  ),
                ),
              );
            }
          },
          child: BlocBuilder<EditionBloc, EditionState>(
            builder: (context, state) {
              if (state is EditionLoaded)
                return MainEditionScreen(
                  edition: state.edition,
                );
              if (state is EditionNotLoaded)
                return MakePaymentScreen(
                  edition: widget.edition,
                  makePaymentBloc: _makePaymentBloc,
                );
              if (state is EditionError) {
                return ErrorScreen(
                  errorMessage: '${state.error}',
                  btnText: 'Try Again',
                  btnOnPressed: () => _editionBloc.add(
                      LoadEdition(edition: widget.edition, showDialog: false)),
                );
              }
              return LoadingWidget();
            },
          ),
        ),
      ),
    );
  }
}
