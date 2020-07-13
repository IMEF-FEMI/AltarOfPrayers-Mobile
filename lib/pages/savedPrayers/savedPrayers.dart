import 'package:altar_of_prayers/blocs/saved_prayers/bloc.dart';
import 'package:altar_of_prayers/models/prayer.dart';
import 'package:altar_of_prayers/pages/paidEditionScreen/prayer.dart';
import 'package:altar_of_prayers/utils/tools.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:altar_of_prayers/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class SavedPrayersScreen extends StatefulWidget {
  @override
  _SavedPrayersScreenState createState() => _SavedPrayersScreenState();
}

class _SavedPrayersScreenState extends State<SavedPrayersScreen> {
  GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  SavedPrayersBloc _savedPrayersBloc;

  @override
  void initState() {
    super.initState();
    _savedPrayersBloc = SavedPrayersBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _savedPrayersBloc.close();
  }

  Future<Null> _reFetchSavedPrayers() async {
    _savedPrayersBloc.add(LoadSavedPrayers());
    // await Future.delayed(Duration(seconds: 1));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SavedPrayersBloc>(
      create: (context) => _savedPrayersBloc..add(LoadSavedPrayers()),
      child: AppScaffold(
        title: "Saved Prayer Points",
        body: BlocBuilder<SavedPrayersBloc, SavedPrayersState>(
          builder: (context, state) {
            if (state is SavedPrayersLoaded && state.prayers.length != 0) {
              return RefreshIndicator(
                key: _refreshKey,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.prayers.length,
                  itemBuilder: (context, index) {
                    Prayer _prayer = state.prayers[index];
                    return Dismissible(
                        // Each Dismissible must contain a Key. Keys allow Flutter to
                        // uniquely identify widgets.
                        key: Key('${_prayer.id}'),
                        // Provide a function that tells the app
                        // what to do after an item has been swiped away.
                        onDismissed: (direction) {
                          // Remove the item from the data source.
                          _savedPrayersBloc.add(RemovePrayer(prayer: _prayer));

                          // Then show a snackbar.
                          Scaffold.of(context)
                              .showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Prayer Point Deleted",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      FlatButton(
                                        color: Colors.red,
                                        onPressed: () {
                                          _savedPrayersBloc.add(UndoRemove(
                                              index: index, prayer: _prayer));
                                          Scaffold.of(context)
                                              .hideCurrentSnackBar();
                                        },
                                        child: Text(
                                          "Undo",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                              .closed
                              .then((value) {
                            if (value == SnackBarClosedReason.timeout) {
                              _savedPrayersBloc
                                  .add(DeletePrayer(prayer: _prayer));
                            }
                          });
                        },
                        // Show a red background as the item is swiped away.
                        background: Container(color: Colors.red),
                        child: PrayerCard(
                          prayer: _prayer,
                          index: index,
                        ));
                  },
                ),
                onRefresh: _reFetchSavedPrayers,
              );
            }
            if (state is SavedPrayersLoaded && state.prayers.length == 0)
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/icons/empty-calendar.svg',
                      height: 100,
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Nothing here",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 20,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              );
            return LoadingWidget();
          },
        ),
      ),
    );
  }
}

class PrayerCard extends StatelessWidget {
  final Prayer prayer;
  final int index;
  const PrayerCard({
    Key key,
    this.prayer,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Center(child: Text(prayer.topic) );
    return InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => PrayerScreen(
                  day: prayer.day,
                  month: prayer.month,
                  year: prayer.year,
                )));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints.expand(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                  child: Icon(
                    FontAwesomeIcons.calendarAlt,
                    size: 50,
                    color: Tools.multiColors[(index % 2)].withOpacity(.8),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          prayer.topic,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${DateFormat('yMMMMd').format(DateTime(prayer.year, prayer.month, prayer.day))}',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Text(
                    //   '${edition['year']}',
                    //   style: Theme.of(context).textTheme.caption,
                    // )
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
