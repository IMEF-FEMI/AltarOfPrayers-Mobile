import 'package:altar_of_prayers/blocs/authentication/bloc.dart';
import 'package:altar_of_prayers/graphql/graphql.dart';
import 'package:altar_of_prayers/utils/altarofprayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // * Get Shared Preference Instance for whole app
  AltarOfPrayers.prefs = await SharedPreferences.getInstance();

  // runApp(ConfigPage());
  final UserRepository userRepository = UserRepository();

  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  runApp(
    GraphQLProvider(
      client: graphQLConfiguration.client,
      child: CacheProvider(
        child: BlocProvider(
          create: (context) => AuthenticationBloc(
            userRepository: userRepository,
          )..add(AppStarted()),
          child: ConfigPage(userRepository: userRepository),
        ),
      ),
    ),
  );
}
