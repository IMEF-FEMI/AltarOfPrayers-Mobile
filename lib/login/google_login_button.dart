import 'package:altar_of_prayers/config/index.dart';
import 'package:altar_of_prayers/login/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'bloc/login_bloc.dart';

class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        BlocProvider.of<LoginBloc>(context).add(LoginWithGooglePressed(),);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.google,
              color: Colors.red,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 16,
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
