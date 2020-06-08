import 'package:altar_of_prayers/pages/config/config_bloc.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'new_page.dart';

class NewEditions extends StatefulWidget {
  @override
  _NewEditionsState createState() => _NewEditionsState();
}

class _NewEditionsState extends State<NewEditions> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Editions',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitRing(
              color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              lineWidth: 3,
            ),
            SizedBox(height: 30),
            Text('Just a Moment...'),
            FlatButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .push(MaterialPageRoute(builder: (context) => NewPage()));
                },
                child: Text('Full Page'))
          ],
        ),
      ),
    );
  }
}

//  Navigator.of(context, rootNavigator: true)
//                       .push(MaterialPageRoute(builder: (context) => NewPage()));