import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Altar Of Prayers',
      body: Container(
        child: Center(
          child: Text('About'),
        ),
      ),
    );
  }
}
