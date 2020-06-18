import 'dart:io';

import 'package:altar_of_prayers/blocs/app_config/index.dart';
import 'package:altar_of_prayers/blocs/authentication/bloc.dart';
import 'package:altar_of_prayers/blocs/edition/bloc.dart';
import 'package:altar_of_prayers/pages/NewEditions/make_payment_screen.dart';
import 'package:altar_of_prayers/repositories/edition_repository.dart';
import 'package:altar_of_prayers/utils/config.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:altar_of_prayers/widgets/error_screen.dart';
import 'package:altar_of_prayers/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewEditionPage extends StatefulWidget {
  final edition;

  const NewEditionPage({Key key, this.edition}) : super(key: key);

  @override
  NewEditionPageState createState() => NewEditionPageState();
}

class NewEditionPageState extends State<NewEditionPage> {
  EditionBloc _editionBloc;
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
    _editionBloc = EditionBloc(editionsRepository: _editionsRepository);
    PaystackPlugin.initialize(publicKey: Config.paystackPublicKey);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditionBloc>(
      create: (context) => _editionBloc..add(LoadEdition(widget.edition)),
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
                      "Cancel",
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
          listener: (context, state) {
            // add snackbar actions here
          },
          child: BlocBuilder<EditionBloc, EditionState>(
            builder: (context, state) {
              if (state is EditionNotLoaded && !state.isLoading)
                return MakePaymentScreen(
                  edition: widget.edition,
                  editionBloc: _editionBloc,
                );
              if (state is EditionLoaded && !state.isLoading)
                return Center(
                  child: Text('Editions Loaded'),
                );
              if (state is EditionError) {
                if (state.error == 'Transaction Failed')
                  return ErrorScreen(
                    errorMessage: '${state.error}',
                    btnText: 'Close',
                    btnOnPressed: () => Navigator.of(context).pop(),
                  );
                if (state.error == 'Opps! an error occured')
                  return ErrorScreen(
                    errorMessage: '${state.error}',
                    btnText: 'Try Again',
                    btnOnPressed: () =>
                        _editionBloc.add(LoadEdition(widget.edition)),
                  );
                return ErrorScreen(
                    errorMessage: '${state.error}',
                    btnText: 'Confirm Payment',
                    btnOnPressed: () => _editionBloc.add(
                          CompleteTransaction(
                            reference: state.reference,
                            editionId: state.editionId,
                          ),
                        ));
              }
              return LoadingWidget();
            },
          ),
        ),
      ),
    );
  }
}
