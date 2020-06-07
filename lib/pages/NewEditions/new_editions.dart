import 'package:altar_of_prayers/pages/NewEditions/bloc/new_editions_bloc.dart';
import 'package:altar_of_prayers/pages/NewEditions/bloc/new_editions_state.dart';
import 'package:altar_of_prayers/pages/config/config_bloc.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NewEditions extends StatelessWidget {
  static const String routeName = '/new-editions';
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewEditionsBloc>(
      create: (context) => NewEditionsBloc(),
      child: AppScaffold(
        title: 'Editions',
        body: BlocBuilder<NewEditionsBloc, NewEditionsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitRing(
                      color:
                          ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                      lineWidth: 3,
                    ),
                    SizedBox(height: 30),
                    Text('Just a Moment...')
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
