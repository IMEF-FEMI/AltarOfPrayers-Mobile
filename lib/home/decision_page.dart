
import 'package:altar_of_prayers/authentication_bloc/bloc.dart';
import 'package:altar_of_prayers/login/login.dart';
import 'package:altar_of_prayers/main_screen/main_screen.dart';
import 'package:altar_of_prayers/repositories/user_repository.dart';
import 'package:altar_of_prayers/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DecisionPage extends StatelessWidget {
  final UserRepository _userRepository;

  DecisionPage({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
        if (state is UnAuthenticated) {
          return LoginScreen(userRepository: _userRepository);
        } else if (state is Authenticated) {
          return MainScreen(user: state.user);
        }
        return Center(
          child: SpinKitCircle(
            color: Tools.multiColors[2],
          ),
        );
      }),
    );
  }
}
