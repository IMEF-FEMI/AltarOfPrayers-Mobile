import 'dart:io';

import 'package:altar_of_prayers/authentication_bloc/bloc.dart';
import 'package:altar_of_prayers/pages/config/config_bloc.dart';
import 'package:altar_of_prayers/utils/config.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
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
  bool _inProgress = false;
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

  @override
  void initState() {
    PaystackPlugin.initialize(publicKey: Config.paystackPublicKey);
    super.initState();
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

    setState(() => _inProgress = true);
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
      setState(() => _inProgress = false);
      // _updateStatus(response.reference, '$response', context);
    } catch (e) {
      setState(() => _inProgress = false);
      // _showMessage("Check console for error", context);
      rethrow;
    }
  }

  _updateStatus(String reference, String message, BuildContext context) {
    _showMessage('Reference: $reference \n\ Response: $message', context,
        const Duration(seconds: 7));
  }

  _showMessage(String message, BuildContext context,
      [Duration duration = const Duration(seconds: 4)]) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar( SnackBar(
        content: new Text(message),
        duration: duration,
        action: new SnackBarAction(
            label: 'CLOSE',
            onPressed: () => Scaffold.of(context)..hideCurrentSnackBar()),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 100),
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
      body: SingleChildScrollView(
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
                  onTap:()=> {_handleCheckout(context)},
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

