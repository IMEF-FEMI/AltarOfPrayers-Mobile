import 'package:altar_of_prayers/authentication_bloc/bloc.dart';
import 'package:altar_of_prayers/config/config_bloc.dart';
import 'package:altar_of_prayers/login/google_login_button.dart';
import 'package:altar_of_prayers/repositories/user_repository.dart';
import 'package:altar_of_prayers/universal/dev_scaffold.dart';
import 'package:altar_of_prayers/universal/image_card.dart';
import 'package:altar_of_prayers/utils/altarofprayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'bloc/bloc.dart';
import 'create_account_button.dart';
import 'login_button.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;
  final VoidCallback _forgotPassword;

  LoginForm(
      {Key key,
      @required UserRepository userRepository,
      VoidCallback forgotPassword})
      : assert(userRepository != null && forgotPassword != null),
        _userRepository = userRepository,
        _forgotPassword = forgotPassword,
        super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  bool _obscurePassword = true;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  void _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordOneChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  bool isRegisterButtonEnabled(LoginState state) {
    print(
        "state.isFormValid: ${state.isFormValid}, isPopulated: $isPopulated, !state.isSubmitting: ${!state.isSubmitting}");
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordOneChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DevScaffold(
        body: BlocListener<LoginBloc, LoginState>(listener: (context, state) {
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
                        child: CircularProgressIndicator(),
                      ),
                      Text(
                        'Loggin In...',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 16,
                            color: Colors.white),
                      )
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
                    child: CircularProgressIndicator(),
                  );
                });
          }
          if (state.isSuccess) {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pop();
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
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
        }, child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
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
                            SizedBox(height: 20.0),
                            TextFormField(
                              controller: _passwordController,
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
                                      _obscurePassword
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      color: Colors.grey,
                                    ),
                                    onTap: () {
                                      _toggleObscurePassword();
                                    },
                                  ),
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff002244)))),
                              obscureText: _obscurePassword,
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              alignment: Alignment(1.0, 0.0),
                              padding: EdgeInsets.only(top: 15.0, left: 20.0),
                              child: InkWell(
                                onTap: widget._forgotPassword,
                                child: Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                      color: ConfigBloc().darkModeOn
                                          ? Colors.white
                                          : Color(0xff002244),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  LoginButton(
                                    onPressed: isRegisterButtonEnabled(state)
                                        ? _onFormSubmitted
                                        : null,
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  GoogleLoginButton(),
                                  CreateAccountButton(
                                      userRepository: widget._userRepository),
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
        })),
        title: "Login");
  }
}
