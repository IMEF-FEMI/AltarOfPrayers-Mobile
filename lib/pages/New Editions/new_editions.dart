import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
class NewEditions extends StatelessWidget {
  static const String routeName = '/new-editions';
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Editions',
      body: Center(
        child: Image(image: AssetImage('assets/gifs/loading.gif')),
      ),
    );
  }
}