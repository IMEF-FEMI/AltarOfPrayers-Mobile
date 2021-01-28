import 'package:altar_of_prayers/blocs/forgot_password/bloc.dart';
import 'package:altar_of_prayers/blocs/login/bloc.dart';
import 'package:altar_of_prayers/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'forgot_password/forgot_password_screen.dart';
import 'login_form.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

enum Page { LOGIN_FORM, FORGOT_PASSWORD_FORM, NEW_PASSWORD_FORM }

class _LoginScreenState extends State<LoginScreen> {
  Page currentcreen = Page.LOGIN_FORM;

  void forgotPaswordScreen() {
    setState(() {
      currentcreen = Page.FORGOT_PASSWORD_FORM;
    });
  }

  void newPaswordScreen() {
    setState(() {
      currentcreen = Page.NEW_PASSWORD_FORM;
    });
  }

  void loginScreen() {
    setState(() {
      currentcreen = Page.LOGIN_FORM;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (currentcreen) {
      case Page.FORGOT_PASSWORD_FORM:
        return BlocProvider<ForgotPasswordBloc>(
          create: (context) =>
              ForgotPasswordBloc(userRepository: widget._userRepository),
          child: ForgotPasswordScreen(
            onCancel: loginScreen,
          ),
        );
        break;

      default:
        return BlocProvider<LoginBloc>(
          create: (context) =>
              LoginBloc(userRepository: widget._userRepository),
          child: LoginForm(
              userRepository: widget._userRepository,
              forgotPassword: forgotPaswordScreen),
        );
    }
  }
}
