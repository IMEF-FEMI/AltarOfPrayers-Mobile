import 'dart:io';

import 'package:altar_of_prayers/blocs/authentication/bloc.dart';
import 'package:altar_of_prayers/blocs/register/bloc.dart';
import 'package:altar_of_prayers/widgets/google_register_button.dart';
import 'package:altar_of_prayers/widgets/image_card.dart';
import 'package:altar_of_prayers/utils/altarofprayers.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:altar_of_prayers/widgets/register_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

import 'register.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({
    Key key,
  }) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordOneController = TextEditingController();
  final TextEditingController _passwordTwoController = TextEditingController();

  RegisterBloc _registerBloc;

  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;

  bool get isPopulated =>
      _nameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _passwordOneController.text.isNotEmpty &&
      _passwordTwoController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordOneController.addListener(_onPasswordOneChanged);
    _passwordTwoController.addListener(_onPasswordTwoChanged);
  }

  void _toggleObscurePassword1() {
    setState(() {
      _obscurePassword1 = !_obscurePassword1;
    });
  }

  void _toggleObscurePassword2() {
    setState(() {
      _obscurePassword2 = !_obscurePassword2;
    });
  }

  void _onEmailChanged() {
    _registerBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordOneChanged() {
    _registerBloc.add(
      PasswordOneChanged(password: _passwordOneController.text),
    );
  }

  void _onPasswordTwoChanged() {
    _registerBloc.add(
      PasswordTwoChanged(
          password1: _passwordOneController.text,
          password2: _passwordTwoController.text),
    );
  }

 
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordOneController.dispose();
    _passwordTwoController.dispose();
    super.dispose();
  }

  void _onFormSubmitted() {
    _registerBloc.add(
      RegisterWithCredentialsPressed(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordOneController.text,
          accountType: "classic"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.isSubmitting && !state.isGoogleAccount) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Platform.isIOS
                                  ? new CupertinoActivityIndicator()
                                  : new CircularProgressIndicator(),
                      ),
                    ],
                  );
                });
          }
          if (state.isSubmitting && state.isGoogleAccount && !state.isFailure) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return Center(
                    child: Platform.isIOS
                                  ? new CupertinoActivityIndicator()
                                  : new CircularProgressIndicator(),
                  );
                });
          }
          if (state.isSuccess) {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pop();
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AssetGiffyDialog(
                      image: Image.asset(
                        'assets/images/email.gif',
                        fit: BoxFit.fitWidth,
                      ),
                      title: Text(
                        'Registration Successful',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.w600),
                      ),
                      description: Text(
                        // 'A verification link has been sent to your email account.'
                        'Please Please check your email to Verify your account',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(),
                      ),
                      onOkButtonPressed: () {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pop();
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(LoggedIn());
                      },
                      onCancelButtonPressed: () {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pop();
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(LoggedIn());
                      },
                    )).whenComplete(() {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pop();
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
            });
          }
          if (state.isFailure) {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pop();
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        state.errorMessage,
                      )),
                      Icon(Icons.error),
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        child:
            BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
          return Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ImageCard(
                      img: AltarOfPrayers.banner_light,
                    ),
                    Container(
                        padding:
                            EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _nameController,
                              autocorrect: false,
                              decoration: InputDecoration(
                                  labelText: 'Full Name',
                                  prefixIcon: Icon(
                                    Icons.text_fields,
                                    color: Colors.grey,
                                  ),
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff002244)))),
                            ),
                            TextFormField(
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
                                  labelText: 'Email',
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: Colors.grey,
                                  ),
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff002244)))),
                            ),
                            TextFormField(
                              controller: _passwordOneController,
                              autovalidate: true,
                              validator: (_) {
                                if (!state.isPasswordValid)
                                  return 'password must be at least 8 characters \nlong contain a number';
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: Colors.grey,
                                  ),
                                  suffixIcon: InkWell(
                                    child: Icon(
                                      _obscurePassword1
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      color: Colors.grey,
                                    ),
                                    onTap: () {
                                      _toggleObscurePassword1();
                                    },
                                  ),
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff002244)))),
                              obscureText: _obscurePassword1,
                            ),
                            TextFormField(
                              controller: _passwordTwoController,
                              autovalidate: true,
                              validator: (_) {
                                if (!state.isPasswordsMatch)
                                  return 'Passwords don\'t match';
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: Colors.grey,
                                  ),
                                  suffixIcon: InkWell(
                                    child: Icon(
                                      _obscurePassword2
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      color: Colors.grey,
                                    ),
                                    onTap: () {
                                      _toggleObscurePassword2();
                                    },
                                  ),
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff002244)))),
                              obscureText: _obscurePassword2,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  RegisterButton(
                                    onPressed: isRegisterButtonEnabled(state)
                                        ? _onFormSubmitted
                                        : null,
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  GoogleRegisterButton(),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
      title: "Register",
    );
  }
}
