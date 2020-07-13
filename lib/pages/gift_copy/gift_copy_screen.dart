import 'package:altar_of_prayers/blocs/gift_copy/bloc.dart';
import 'package:altar_of_prayers/blocs/make_payment/bloc.dart';
import 'package:altar_of_prayers/pages/make_payment/make_payment_screen.dart';
import 'package:altar_of_prayers/widgets/error_screen.dart';
import 'package:altar_of_prayers/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';


class GiftCopyScreen extends StatefulWidget {
  final int editionId;

  const GiftCopyScreen({Key key, @required this.editionId}) : super(key: key);

  @override
  _GiftCopyScreenState createState() => _GiftCopyScreenState();
}

class _GiftCopyScreenState extends State<GiftCopyScreen> {
  final TextEditingController _emailController = TextEditingController();
  GiftCopyBloc giftCopyBloc;
  MakePaymentBloc makePaymentBloc;

  bool isFindUserButtonEnabled(GiftCopyInitial state) {
    return state.isEmailValid && _emailController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    makePaymentBloc = MakePaymentBloc();
    giftCopyBloc = GiftCopyBloc(makePaymentBloc: makePaymentBloc);
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    super.dispose();
    giftCopyBloc.close();
    makePaymentBloc.close();
  }

  void _onEmailChanged() {
    giftCopyBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GiftCopyBloc>(
      create: (context) => giftCopyBloc,
      child: Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<GiftCopyBloc, GiftCopyState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (state is GiftCopyLoading) LoadingWidget(),
                      if (state is GiftCopyInitial)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            autocorrect: false,
                            autovalidate: true,
                            validator: (_) {
                              return !state.isEmailValid
                                  ? 'Invalid Email'
                                  : null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Enter User Email',
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: Colors.grey,
                                ),
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff002244)))),
                          ),
                        ),
                      if (state is UserFound)
                        MakePaymentScreen(
                          edition: {"id": widget.editionId},
                          paidFor: state.email,
                          fullName: state.fullName,
                          makePaymentBloc: makePaymentBloc,
                        ),
                      if (state is GiftedSuccessfulState)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/icons/credit-card.svg',
                              height: 100,
                            ),
                            SizedBox(height: 30),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "Payment Successful",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      fontSize: 20,
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RaisedButton(
                              color: Colors.red,
                              splashColor: Colors.white.withOpacity(.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'close',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      if (state is GiftCopyInitial) SizedBox(height: 20.0),
                      if (state is GiftCopyInitial)
                        RaisedButton(
                          color: Theme.of(context).accentColor,
                          splashColor: Colors.white.withOpacity(.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onPressed: isFindUserButtonEnabled(state)
                              ? () {
                                  giftCopyBloc.add(FindUser(
                                      email: _emailController.text,
                                      editionId: widget.editionId));
                                }
                              : null,
                          child: Text(
                            'Find User',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      if (state is Error)
                        ErrorScreen(
                          errorMessage: state.error,
                          btnText: "Try Again",
                          btnOnPressed: () => giftCopyBloc.add(FindUser(
                              email: _emailController.text,
                              editionId: widget.editionId)),
                        ),
                      if (state is UserAlreadyHasACopy)
                        Column(
                          children: <Widget>[
                            Center(
                              child: SvgPicture.asset(
                                'assets/icons/study.svg',
                                fit: BoxFit.contain,
                                height: MediaQuery.of(context).size.height * .3,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "${_emailController.text} \n Already has a copy of this Edition",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      fontSize: 20,
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RaisedButton(
                              color: Colors.red,
                              splashColor: Colors.white.withOpacity(.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'close',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      if (state is UserNotFound)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/icons/empty.svg',
                              height: 100,
                            ),
                            SizedBox(height: 30),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "User Not Registered",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      fontSize: 20,
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            RaisedButton(
                              color: Color(0xff09b2c3),
                              splashColor: Colors.white.withOpacity(.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onPressed: () {
                                giftCopyBloc.add(
                                    InviteUser(email: _emailController.text));
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Send Invite Link',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }
}
