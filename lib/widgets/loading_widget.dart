import 'package:altar_of_prayers/blocs/app_config/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitRing(
            color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            lineWidth: 3,
          ),
          SizedBox(height: 30),
          Text('Just a Moment...'),
        ],
      ),
    );
  }
}
