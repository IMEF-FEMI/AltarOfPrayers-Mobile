import 'dart:async';

import 'package:altar_of_prayers/repositories/user_repository.dart';
import 'package:altar_of_prayers/utils/validators.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;
  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsToState(
        event.email,
        event.password,
      );
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    }
  }

    Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    try {
      yield LoginState.googleLoading();
      await _userRepository.signInWithGoogle();
      yield LoginState.success();
    } catch (e) {
     yield LoginState.failure(error: (e.toString()));
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsToState(
    String email,
    String password,
  ) async* {
    yield LoginState.loading();
    try {
      await _userRepository.login(
        email: email,
        password: password,
      );
      // print("user after registration ${user.toDatabaseJson()}");
      yield LoginState.success();
      // yield RegisterState.failure(error: "Success");
    } catch (e) {
      print("Error: $e");
      yield LoginState.failure(error: (e.toString()));
    }
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email));
  }
}
