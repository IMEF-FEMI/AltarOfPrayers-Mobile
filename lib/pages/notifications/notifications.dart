import 'package:altar_of_prayers/blocs/notificaions/bloc.dart';
import 'package:altar_of_prayers/models/notification.dart';
import 'package:altar_of_prayers/utils/tools.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:altar_of_prayers/widgets/badge_decoration.dart';
import 'package:altar_of_prayers/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'notification_detail.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  NotificationsBloc _notificationsBloc;
  GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _notificationsBloc = NotificationsBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _notificationsBloc.close();
  }

  Future<Null> _reFetchNotifications() async {
    _notificationsBloc.add(LoadNotifications());
    // await Future.delayed(Duration(seconds: 1));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsBloc>(
      create: (context) => _notificationsBloc..add(LoadNotifications()),
      child: AppScaffold(
          title: 'Altar Of Prayers',
          body: BlocBuilder<NotificationsBloc, NotificationsState>(
              builder: (context, state) {
            if (state is NotificationsLoaded &&
                state.notifications.length != 0) {
              return RefreshIndicator(
                  key: _refreshKey,
                  onRefresh: _reFetchNotifications,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.notifications.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<NotificationModel>(
                          future: state.notifications[index],
                          builder: (BuildContext context,
                              AsyncSnapshot<NotificationModel> snapshot) {
                            if (snapshot.hasData) {
                              NotificationModel notification = snapshot.data;
                              return Dismissible(
                                  key: Key('${notification.id}'),
                                  onDismissed: (direction) {
                                    // Remove the item from the data source.
                                    // _savedPrayersBloc.add(RemovePrayer(prayer: _prayer));

                                    // // Then show a snackbar.
                                    // Scaffold.of(context)
                                    //     .showSnackBar(
                                    //       SnackBar(
                                    //         backgroundColor: Colors.red,
                                    //         content: Row(
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.spaceBetween,
                                    //           children: <Widget>[
                                    //             Text(
                                    //               "Prayer Point Deleted",
                                    //               style: TextStyle(
                                    //                   color: Colors.white, fontSize: 20),
                                    //             ),
                                    //             FlatButton(
                                    //               color: Colors.red,
                                    //               onPressed: () {
                                    //                 _savedPrayersBloc.add(UndoRemove(
                                    //                     index: index, prayer: _prayer));
                                    //                 Scaffold.of(context)
                                    //                     .hideCurrentSnackBar();
                                    //               },
                                    //               child: Text(
                                    //                 "Undo",
                                    //                 style: TextStyle(
                                    //                     color: Colors.white,
                                    //                     fontSize: 20),
                                    //               ),
                                    //             )
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     )
                                    //     .closed
                                    //     .then((value) {
                                    //   if (value == SnackBarClosedReason.timeout) {
                                    //     _savedPrayersBloc
                                    //         .add(DeletePrayer(prayer: _prayer));
                                    //   }
                                    // });
                                  },
                                  // Show a red background as the item is swiped away.
                                  background: Container(color: Colors.red),
                                  child: NotificationCard(
                                    notification: notification,
                                    index: index,
                                  ));
                            }
                            return Container();
                          });
                    },
                  ));
            }
            if (state is NotificationsLoaded &&
                state.notifications.length == 0) {
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
            }
            return LoadingWidget();
          })),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final int index;

  const NotificationCard({Key key, this.notification, this.index})
      : super(key: key);
  BadgeDecoration buildBadgeDecoration() {
    // show new badge if edition has not been seen and user has not paid

    if (notification.read == false)
      return const BadgeDecoration(
          badgeColor: Colors.red,
          badgeSize: 50,
          textSpan: TextSpan(
            text: "Unread",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ));

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => NotificationDetail(
                  notification: notification,
                )));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        child: Container(
          foregroundDecoration: buildBadgeDecoration(),
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
                    FontAwesomeIcons.bell,
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
                          notification.title,
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
