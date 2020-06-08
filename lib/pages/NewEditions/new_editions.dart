import 'package:altar_of_prayers/pages/NewEditions/bloc/bloc.dart';
import 'package:altar_of_prayers/pages/config/config_bloc.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'bloc/new_editions_bloc.dart';

class NewEditions extends StatefulWidget {
  @override
  _NewEditionsState createState() => _NewEditionsState();
}

class _NewEditionsState extends State<NewEditions> {
  Widget _loadingPage() {
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

  Widget _errorPage(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
             Icon(FontAwesomeIcons.exclamationTriangle, size: 50, color: Colors.red[800],) ,
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Oops! an Error Occured',
              style: Theme.of(context).textTheme.title.copyWith(
                    fontSize: 25,
                  ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          FlatButton.icon(
            icon:Icon( FontAwesomeIcons.redo),
            color: Colors.grey[500],
            onPressed: () =>
                BlocProvider.of<NewEditionsBloc>(context).add(ReFreshEvent()),
            label: Text('Try Again!'),
            
          )
        ],
      ),
    );
  }

  Widget _editionsPage(List editions) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${editions.length} Editions published'),
        ],
      ),
    );
  }

  Widget _noEditionsPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
         Icon(FontAwesomeIcons.calendarTimes, size: 50, color: Colors.teal[800],) ,
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'No Edition has been published yet! check back later',
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
      child: BlocBuilder<NewEditionsBloc, NewEditionsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return AppScaffold(title: 'Editions', body: _loadingPage());
          } else if (state.isFailure) {
            return AppScaffold(title: 'Editions', body: _errorPage(context));
          } else if (state.editions.length != 0) {
            return AppScaffold(
                title: 'Editions', body: _editionsPage(state.editions));
          } else
            print(state);
          return AppScaffold(title: 'Editions', body: _noEditionsPage());
        },
      ),
    );
  }
}

//  Navigator.of(context, rootNavigator: true)
//                       .push(MaterialPageRoute(builder: (context) => NewPage()));
