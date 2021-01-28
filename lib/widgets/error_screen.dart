import 'package:altar_of_prayers/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;
  final String btnText;
  final Function btnOnPressed;

  const ErrorScreen(
      {Key key, this.errorMessage, this.btnText, this.btnOnPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            'assets/icons/alert.svg',
            height: 100,
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '$errorMessage',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontSize: 20,
                  ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          if (btnText != null)
            FlatButton(
              color: Tools.multiColors[0],
              onPressed: btnOnPressed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                '$btnText',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
        ],
      ),
    );
  }
}
