import 'package:altar_of_prayers/authentication_bloc/bloc.dart';
import 'package:altar_of_prayers/models/user.dart';
import 'package:altar_of_prayers/universal/dev_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  final User user;

  const MainScreen({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DevScaffold(
      title: 'Altar Of Prayers',
      logout: () {
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
      },
      body: Center(
          child: ListView(
        children: <Widget>[
          Text(user.fullName),
          Text(user.email),
          Text(user.accountType),
          Text(user.admin.toString()),
        ],
      )),
    );
  }
}
