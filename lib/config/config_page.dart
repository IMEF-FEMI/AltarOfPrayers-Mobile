import 'package:altar_of_prayers/home/decision_page.dart';
import 'package:altar_of_prayers/repositories/user_repository.dart';
import 'package:altar_of_prayers/utils/altarofprayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'index.dart';

class ConfigPage extends StatefulWidget {
  final UserRepository _userRepository;

  ConfigPage({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  ConfigBloc configBloc;

  @override
  void dispose() {
    configBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setupApp();
  }

  setupApp() {
    configBloc = ConfigBloc();
    configBloc.darkModeOn =
        AltarOfPrayers.prefs.getBool(AltarOfPrayers.darkModePref) ?? false;
  }

  ThemeData darkTheme() {
    return ThemeData(
      //* Custom Google Font
      fontFamily: AltarOfPrayers.google_sans_family,
      primaryColor: Colors.black,
      accentColor: Colors.lightBlue,
      disabledColor: Colors.grey,
      cardColor: Colors.black,
      canvasColor: Colors.black,
      brightness: Brightness.dark,
      buttonTheme: Theme.of(context)
          .buttonTheme
          .copyWith(colorScheme: ColorScheme.dark()),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
      ),
    );
  }

  ThemeData lightTheme() {
    return ThemeData(
      //* Custom Google Font
      fontFamily: AltarOfPrayers.google_sans_family,
      // primarySwatch: Colors.red,
//               const Color lightThemeAccentColor = Color(0xff002244);
// const Color darkThemeAccentColor = Color(0xff054280);
      primaryColor: Colors.white,
      disabledColor: Colors.grey,
      cardColor: Colors.white,
      canvasColor: Colors.white,
      brightness: Brightness.light,
      buttonTheme: Theme.of(context)
          .buttonTheme
          .copyWith(colorScheme: ColorScheme.light()),

      appBarTheme: AppBarTheme(
        elevation: 0.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => configBloc,
      child: BlocBuilder<ConfigBloc, ConfigState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Altar Of Prayers',
            debugShowCheckedModeBanner: false,
            theme: configBloc.darkModeOn ? darkTheme() : lightTheme(),
            home: DecisionPage(
              userRepository: widget._userRepository,
            ),
          );
        },
      ),
    );
  }
}
