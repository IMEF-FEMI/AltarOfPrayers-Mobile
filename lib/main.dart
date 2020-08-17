import 'package:altar_of_prayers/blocs/authentication/bloc.dart';
import 'package:altar_of_prayers/database/dark_mode_dao.dart';
import 'package:altar_of_prayers/graphql/graphql.dart';
import 'package:altar_of_prayers/models/notification.dart';
import 'package:altar_of_prayers/repositories/notifications_repository.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'pages/config/config_page.dart';
import 'repositories/user_repository.dart';
import 'utils/simple_bloc_delegate.dart';
import 'package:altar_of_prayers/widgets/notification_plugin.dart';

NotificationsRepository _notificationsRepository = NotificationsRepository();

onNotificationInLowerVersions(ReceivedNotification receivedNotification) {}
onNotificationClick(NotificationModel notification) {
  _notificationsRepository.markNotificationAsRead(id: notification.id);
}

void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] Headless event received.');
  await getNotificationsAndNotify(taskId);
}

Future<void> getNotificationsAndNotify(String taskId) async {
  notificationPlugin
      .setListenerForLowerFunctions(onNotificationInLowerVersions);

  List notificationsFromServer =
      await _notificationsRepository.getNotificationsFromServer();

  notificationsFromServer.forEach((notification) {
    notificationPlugin.setOnNotificationClick(onNotificationClick);

    if ((notification as NotificationModel).read == false)
      notificationPlugin.showNotification(
        receivedNotification: ReceivedNotification(
          title: notification.title,
          body: notification.message,
          payload: notification.message,
        ),
      );
  });
  BackgroundFetch.finish(taskId);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      // statusBarColor: Colors.transparent,
      statusBarColor: Colors.white10,
    ),
  );

  //* Forcing only portrait orientation
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  var brightness = SchedulerBinding.instance.window.platformBrightness;
  bool deviceDarkMode = brightness == Brightness.dark;

  final UserRepository userRepository = UserRepository();
  // * first check if device dark mode is on else get last darkmode value from db
  bool darkModeOn =
      deviceDarkMode == true ? true : await DarkModeDao().darkModeOn();

  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  runApp(
    RestartWidget(
      child: GraphQLProvider(
        client: graphQLConfiguration.client,
        child: CacheProvider(
          child: BlocProvider(
            create: (context) => AuthenticationBloc(
              userRepository: userRepository,
            )..add(AppStarted()),
            child: ConfigPage(
              userRepository: userRepository,
              darkModeOn: darkModeOn,
            ),
          ),
        ),
      ),
    ),
  );

  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          forceAlarmManager: false,
          stopOnTerminate: false,
          startOnBoot: true,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.NONE,
          // forceAlarmManager: true,
        ), (String taskId) async {
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");
      await getNotificationsAndNotify(taskId);
    }).then((int status) async {
      print('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
    });
  }

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
