import 'dart:io';

import 'package:altar_of_prayers/blocs/authentication/bloc.dart';
import 'package:altar_of_prayers/blocs/edition/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MakePaymentScreen extends StatefulWidget {
  final edition;
  final EditionBloc editionBloc;

  const MakePaymentScreen({Key key, this.edition, this.editionBloc})
      : super(key: key);

  @override
  _MakePaymentScreenState createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {
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

  threeSidedBorderRadius({double radius = 8}) {
    return BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
        bottomRight: Radius.circular(radius));
  }

  String _getReference({String email}) {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom_${email}_${platform}_${DateTime.now().millisecondsSinceEpoch}';
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

    charge.reference =
        _getReference(email: (authState as Authenticated).user.email);

    try {
      CheckoutResponse response = await PaystackPlugin.checkout(
        context,
        method: CheckoutMethod.card,
        charge: charge,
        fullscreen: false,
        // logo: MyLogo(),
      );
      print('Response = $response');
      // print(response.reference);
      widget.editionBloc.add(CompleteTransaction(
        reference: response.reference,
        editionId: widget.edition['id'],
      ));
    } catch (e) {
      print(e);

      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Hero(
                tag: widget.edition['name'],
                child: SvgPicture.asset(
                  'assets/icons/bible.svg',
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height * .3,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
              ),
              child: InkWell(
                borderRadius: threeSidedBorderRadius(radius: 15),
                onTap: () => {_handleCheckout(context)},
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: threeSidedBorderRadius(radius: 15),
                      border: Border.all(color: Colors.grey)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints.expand(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.3,
                          ),
                          child: Icon(
                            FontAwesomeIcons.solidCreditCard,
                            size: 80,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.edition['name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .copyWith(fontSize: 15)),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              months[int.parse(
                                  '${widget.edition['startingMonth']}')],
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subtitle),
                          SizedBox(
                            height: 5,
                          ),
                          Text('${widget.edition['year']}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subtitle),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            FlatButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Colors.green,
              onPressed: () => {_handleCheckout(context)},
              icon: Icon(Icons.credit_card, color: Colors.white,),
              label: Text('Make Payment', style: TextStyle(color:Colors.white),),
            )
          ],
        ),
      ),
    );
  }
}
