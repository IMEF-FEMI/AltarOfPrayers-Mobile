import 'dart:convert';

import 'package:altar_of_prayers/blocs/new_editions/bloc.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:altar_of_prayers/widgets/edition_card.dart';
import 'package:altar_of_prayers/widgets/error_screen.dart';
import 'package:altar_of_prayers/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewEditionsPage extends StatefulWidget {
  @override
  _NewEditionsPageState createState() => _NewEditionsPageState();
}

class _NewEditionsPageState extends State<NewEditionsPage> {
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  NewEditionsBloc _newEditionsBloc;

  @override
  void initState() {
    super.initState();
    _newEditionsBloc = NewEditionsBloc();
    fetchNewEditions();
  }

  Future<Null> fetchNewEditions() async{
    _newEditionsBloc.add(LoadEditions());
    await Future.delayed(Duration(seconds: 2));
    return null;
  }

  Widget _noEditionsPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //  Icon(FontAwesomeIcons.calendarTimes, size: 50, color: Colors.teal[800],) ,
          SvgPicture.asset(
            'assets/icons/empty.svg',
            height: 80,
          ),

          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Sorry! No Edition has been published Yet',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewEditionsBloc>(
      create: (context) => _newEditionsBloc..add(LoadEditions()),
      child: AppScaffold(
        title: 'Editions',
        body: BlocBuilder<NewEditionsBloc, NewEditionsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return LoadingWidget();
            } else if (state.isFailure) {
              return ErrorScreen(
                errorMessage: 'Oops! an Error Occured',
                btnText: 'Try Again',
                btnOnPressed: () => BlocProvider.of<NewEditionsBloc>(context)
                    .add(LoadEditions()),
              );
            } else if (state.editions.length != 0) {
              return RefreshIndicator(
                key: refreshKey,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.editions.length,
                  itemBuilder: (context, index) {
                    return EditionCard(
                        edition: JsonDecoder().convert(state.editions[index]),
                        seenEditions: state.seenEditions);
                  },
                ),
                onRefresh: fetchNewEditions,
              );
            } else
              return _noEditionsPage();
          },
        ),
      ),
    );
  }
}
