import 'dart:convert';

import 'package:altar_of_prayers/blocs/new_editions/bloc.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:altar_of_prayers/widgets/edition_card.dart';
import 'package:altar_of_prayers/widgets/error_screen.dart';
import 'package:altar_of_prayers/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewEditions extends StatefulWidget {
  @override
  _NewEditionsState createState() => _NewEditionsState();
}

class _NewEditionsState extends State<NewEditions> {
  Widget _editionsPage(List editions) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: editions.length,
      itemBuilder: (context, index) {
        return EditionCard(
          edition: JsonDecoder().convert(editions[index]),
        );
      },
    );
  }

  Widget _noEditionsPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //  Icon(FontAwesomeIcons.calendarTimes, size: 50, color: Colors.teal[800],) ,
          SvgPicture.asset(
            'assets/icons/shopping-cart.svg',
            height: 80,
          ),

          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Sorry! No New Editions',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.title.copyWith(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewEditionsBloc>(
      create: (context) => NewEditionsBloc()..add(ReFreshEvent()),
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
                    .add(ReFreshEvent()),
              );
            } else if (state.editions.length != 0) {
              return _editionsPage(state.editions);
            } else
              return _noEditionsPage();
          },
        ),
      ),
    );
  }
}
