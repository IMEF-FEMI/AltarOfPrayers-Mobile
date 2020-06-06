import 'package:altar_of_prayers/pages/config/index.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:altar_of_prayers/widgets/image_card.dart';
import 'package:altar_of_prayers/utils/altarofprayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

import 'bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final VoidCallback onCancel;

  const ForgotPasswordScreen({Key key, this.onCancel}) : super(key: key);
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

enum PasswordScreen { ENTER_TOKEN, ENTER_EMAIL }

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  // context
  BuildContext screenContext;

  // controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _passwordOneController = TextEditingController();
  final TextEditingController _passwordTwoController = TextEditingController();

  PasswordScreen currentScreen = PasswordScreen.ENTER_EMAIL;
  ForgotPasswordBloc _forgotPasswordBloc;

  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
      _tokenController.text.isNotEmpty &&
      _passwordOneController.text.isNotEmpty &&
      _passwordTwoController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _forgotPasswordBloc = BlocProvider.of<ForgotPasswordBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordOneController.addListener(_onPasswordOneChanged);
    _passwordTwoController.addListener(_onPasswordTwoChanged);
    _tokenController.addListener(_onTokenChanged);
  }

  void _onEmailChanged() {
    _forgotPasswordBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordOneChanged() {
    _forgotPasswordBloc
        .add(PasswordOneChanged(password: _passwordOneController.text));
  }

  void _onPasswordTwoChanged() {
    _forgotPasswordBloc.add(PasswordTwoChanged(
        password1: _passwordOneController.text,
        password2: _passwordTwoController.text));
  }

  void _onTokenChanged() {
    _forgotPasswordBloc.add(TokenChanged(token: _tokenController.text));
  }

  bool isSendPasswordResetEmailButtonEnabled(ForgotPasswordState state) {
    if (state is ForgotPasswordFormState) {
      return state.isEmailValid && !state.isSendingEmail;
    }

    return true;
  }

  bool isSavePasswordButtonEnabled(ForgotPasswordState state) {
    if (state is ForgotPasswordFormState) {
      return isPopulated && state.isFormValid && !state.isSubmitting;
    }

    return true;
  }

  void _onSendPasswordResetEmailButtonPressed() {
    // send email here
    // wait for response
    // then change current screen
    _forgotPasswordBloc
        .add(SendPasswordResetEmail(email: _emailController.text));
  }

  void _onSavePasswordButtonPressed() {
    _forgotPasswordBloc.add(SaveNewPassword(
        email: _emailController.text,
        token: _tokenController.text,
        newPassword: _passwordOneController.text));
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

  bool isEmailValid(state) {
    if (state is ForgotPasswordFormState) {
      return state.isEmailValid;
    }
    return true;
  }

  bool isTokenValid(state) {
    if (state is ForgotPasswordFormState) {
      return state.isTokenValid;
    }
    return true;
  }

  bool isPasswordValid(state) {
    if (state is ForgotPasswordFormState) {
      return state.isPasswordValid;
    }
    return true;
  }

  bool isPasswordsMatch(state) {
    if (state is ForgotPasswordFormState) {
      return state.isPasswordsMatch;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    screenContext = context;
    return AppScaffold(
      title: 'Forgot Password',
      body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordFormState && state.isSendingEmail) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                      Text(
                        'Resseting Password...',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 16,
                            color: Colors.white),
                      )
                    ],
                  );
                });
          }
          if (state is ForgotPasswordFormState && state.isEmailSent) {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pop();
            showDialog(
                context: context,
                builder: (context) => AssetGiffyDialog(
                      image: Image.asset(
                        'assets/images/email.gif',
                        fit: BoxFit.fitWidth,
                      ),
                      title: Text(
                        'Success',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.w600),
                      ),
                      description: Text(
                        'Please check your email to retreive the Password reset code sent',
                        textAlign: TextAlign.center,
                        style: TextStyle(),
                      ),
                      onOkButtonPressed: () {
                        currentScreen = PasswordScreen.ENTER_TOKEN;
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                    )).whenComplete(() {
              // widget.onCancel();
              if (currentScreen != PasswordScreen.ENTER_TOKEN) {
                currentScreen = PasswordScreen.ENTER_TOKEN;
                setState(() {});
              }
            });
          }
          if (state is ForgotPasswordError) {
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
                        state.error,
                      )),
                      Icon(Icons.error),
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }
          if (state is ForgotPasswordFormState && state.isSubmitting) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Resseting Password...',
                          style: TextStyle(
                              color: ConfigBloc().darkModeOn
                                  ? Colors.black
                                  : Colors.white)),
                      CircularProgressIndicator(),
                    ],
                  ),
                  backgroundColor: ConfigBloc().darkModeOn
                      ? Colors.white
                      : Color(0xFF002244),
                ),
              );
          }

          if (state is ForgotPasswordFormState && state.isSuccess) {
            showDialog(
                context: context,
                builder: (context) => AssetGiffyDialog(
                      image: Image.asset(
                        'assets/images/success.gif',
                        fit: BoxFit.fitWidth,
                      ),
                      title: Text(
                        'Success',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.w600),
                      ),
                      description: Text(
                        'Your Password as been Successfully changed',
                        textAlign: TextAlign.center,
                        style: TextStyle(),
                      ),
                      onOkButtonPressed: () {
                        currentScreen = PasswordScreen.ENTER_TOKEN;
                        Navigator.of(context).pop();
                        widget.onCancel();
                      },
                    )).whenComplete(() {
              // widget.onCancel();
              widget.onCancel();
            });
          }
        },
        child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          builder: (context, state) {
            return Form(
              key: currentScreen == PasswordScreen.ENTER_EMAIL
                  ? _formKey
                  : _formKey1,
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
                            EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              autocorrect: false,
                              autovalidate: true,
                              enabled:
                                  currentScreen != PasswordScreen.ENTER_TOKEN,
                              validator: (value) {
                                print(value.toString());

                                return !isEmailValid(state)
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
                            if (currentScreen == PasswordScreen.ENTER_TOKEN)
                              Column(
                                children: <Widget>[
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _tokenController,
                                    autocorrect: false,
                                    autovalidate: true,
                                    validator: (value) => !isTokenValid(state)
                                        ? 'Please enter the correct token'
                                        : null,
                                    decoration: InputDecoration(
                                        labelText: 'Password Reset Token',
                                        prefixIcon: Icon(
                                          Icons.vpn_key,
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
                                    validator: (value) => !isPasswordValid(
                                            state)
                                        ? 'password must be at least 8 characters \nlong contain a number'
                                        : null,
                                    decoration: InputDecoration(
                                        labelText: 'New Password',
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
                                    validator: (value) =>
                                        !isPasswordsMatch(state)
                                            ? 'Passwords don\'t match'
                                            : null,
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
                                ],
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            if (currentScreen != PasswordScreen.ENTER_TOKEN)
                              RaisedButton(
                                onPressed:
                                    isSendPasswordResetEmailButtonEnabled(state)
                                        ? _onSendPasswordResetEmailButtonPressed
                                        : null,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                // color: Colors.white,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Reset Password',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            else
                              RaisedButton(
                                onPressed: isSavePasswordButtonEnabled(state)
                                    ? _onSavePasswordButtonPressed
                                    : null,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                // color: Colors.white,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Save Password',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            FlatButton(
                              onPressed: widget.onCancel,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
