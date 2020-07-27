import 'package:altar_of_prayers/blocs/authentication/bloc.dart';
import 'package:altar_of_prayers/database/dark_mode_dao.dart';
import 'package:altar_of_prayers/graphql/graphql.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'pages/config/config_page.dart';
import 'repositories/user_repository.dart';
import 'utils/simple_bloc_delegate.dart';

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

  // * get last darkmode value from db
  bool darkModeOn = await DarkModeDao().darkModeOn();
  final UserRepository userRepository = UserRepository();

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
