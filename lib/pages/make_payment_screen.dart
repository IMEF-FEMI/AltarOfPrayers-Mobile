import 'dart:io';

import 'package:altar_of_prayers/blocs/authentication/bloc.dart';
import 'package:altar_of_prayers/blocs/make_payment/bloc.dart';
import 'package:altar_of_prayers/utils/config.dart';
import 'package:altar_of_prayers/widgets/edition_detail_card.dart';
import 'package:altar_of_prayers/widgets/error_screen.dart';
import 'package:altar_of_prayers/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MakePaymentScreen extends StatefulWidget {
  final edition;
  final String paidFor;
  final String fullName;
  final MakePaymentBloc makePaymentBloc;

  const MakePaymentScreen({
    Key key,
    this.edition,
    this.paidFor,
    this.fullName,
    this.makePaymentBloc,
  }) : super(key: key);

  @override
  _MakePaymentScreenState createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {
  MakePaymentBloc _makePaymentBloc;

  String _cardNumber;
  String _cvv;
  int _expiryMonth = 0;
  int _expiryYear = 0;

  final months = {
    1: 'January - March',
    4: 'April - June',
    7: 'July - September',
    10: 'October - December',
  };

  String _getReference({String email}) {
    var authState = BlocProvider.of<AuthenticationBloc>(context).state;

    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom_${(authState as Authenticated).user.email}_${platform}_${DateTime.now().millisecondsSinceEpoch}_paidFor_${email != null ? email : "self"}';
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumber,
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
    );
  }

  _handleCheckout(BuildContext context) async {
    var authState = BlocProvider.of<AuthenticationBloc>(context).state;

    Charge charge = Charge()
      ..amount = 30000 // In base currency
      ..email = (authState as Authenticated).user.email
      ..card = _getCardFromUI();

    charge.reference = _getReference(email: widget.paidFor);

    try {
      CheckoutResponse response = await PaystackPlugin.checkout(
        context,
        method: CheckoutMethod.card,
        charge: charge,
        fullscreen: false,
        // logo: MyLogo(),
      );
      print('Response = ${response.status}');
      // print(response.reference);
      if (response.status == true)
        _makePaymentBloc.add(CompleteTransaction(
          reference: response.reference,
          editionId: widget.edition['id'],
          paidFor: widget.paidFor,
        ));
    } catch (e) {
      print(e);

      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _makePaymentBloc = widget.makePaymentBloc;
    PaystackPlugin.initialize(publicKey: Config.paystackPublicKey);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MakePaymentBloc>(
      create: (context) => _makePaymentBloc
        ..add(
          CheckForIncompleteTransactions(editionId: widget.edition['id']),
        ),
      child: BlocBuilder<MakePaymentBloc, MakePaymentState>(
          builder: (context, state) {
        if (state is ShowPaymentScreen)
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: SvgPicture.asset(
                      'assets/icons/bible.svg',
                      fit: BoxFit.contain,
                      height: MediaQuery.of(context).size.height * .3,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (widget.paidFor == null)
                    EditionDetailCard(
                      title: widget.edition['name'],
                      subtitle: months[
                          int.parse('${widget.edition['startingMonth']}')],
                      caption: '${widget.edition['year']}',
                      leadingIcon: Icon(
                        FontAwesomeIcons.solidCreditCard,
                        size: 80,
                      ),
                      onPressed: () => {_handleCheckout(context)},
                    ),
                  SizedBox(
                    height: 5,
                  ),
                  if(widget.paidFor !=null)
                       Column(
                    children: <Widget>[
                      Text(widget.fullName,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5),
                      Text(
                          widget.paidFor,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6),
                    ],
                  ),
                   SizedBox(
                    height: 10,
                  ),
                  FlatButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: Colors.green,
                    onPressed: () => {_handleCheckout(context)},
                    icon: Icon(
                      Icons.credit_card,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Make Payment',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          );
        if (state is PaymentFailed) {
          if (state.error == 'Transaction Failed')
            return ErrorScreen(
              errorMessage: '${state.error}',
              btnText: 'Close',
              btnOnPressed: () => _makePaymentBloc.add(
                  CheckForIncompleteTransactions(editionId: state.editionId)),
            );

          return ErrorScreen(
              errorMessage: '${state.error}',
              btnText: 'Confirm Payment',
              btnOnPressed: () => _makePaymentBloc.add(
                    CompleteTransaction(
                      reference: state.reference,
                      editionId: state.editionId,
                    ),
                  ));
        }
        return LoadingWidget();
      }),
    );
  }
}
