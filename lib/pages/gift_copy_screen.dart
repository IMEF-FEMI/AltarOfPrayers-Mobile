import 'package:altar_of_prayers/blocs/gift_copy/bloc.dart';
import 'package:altar_of_prayers/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GiftCopyScreen extends StatefulWidget {
  final int editionId;

  const GiftCopyScreen({Key key, @required this.editionId}) : super(key: key);

  @override
  _GiftCopyScreenState createState() => _GiftCopyScreenState();
}

class _GiftCopyScreenState extends State<GiftCopyScreen> {
  final TextEditingController _emailController = TextEditingController();
  GiftCopyBloc giftCopyBloc;
  bool isFindUserButtonEnabled(GiftCopyInitial state) {
    return state.isEmailValid && _emailController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    giftCopyBloc = GiftCopyBloc();
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    super.dispose();
    giftCopyBloc.close();
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
                return Column(
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
                            return !state.isEmailValid ? 'Invalid Email' : null;
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
                      )
                  ],
                );
              },
            )),
      ),
    );
  }
}
