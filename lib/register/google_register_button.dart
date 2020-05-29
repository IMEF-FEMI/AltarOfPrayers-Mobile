import 'package:altar_of_prayers/config/config_bloc.dart';
import 'package:altar_of_prayers/register/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleRegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return OutlineButton(
      splashColor: Colors.grey,
       onPressed: () {
        BlocProvider.of<RegisterBloc>(context).add(
          RegisterWithGooglePressed(),
        );
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
            Icon(FontAwesomeIcons.google, color: Colors.red,),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign up with Google',
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


