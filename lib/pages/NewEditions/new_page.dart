import 'package:altar_of_prayers/pages/config/config_bloc.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NewPage extends StatefulWidget {

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
 
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'More Detailed Page',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitRing(
              color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              lineWidth: 3,
            ),
            SizedBox(height: 30),
            Text('Just a Moment...')
          ],
        ),
      ),
    );
  }
}
