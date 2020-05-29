import 'package:altar_of_prayers/repositories/user_repository.dart';
import 'package:altar_of_prayers/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'bloc.dart';
import 'package:rxdart/rxdart.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final UserRepository _userRepository;

  ForgotPasswordBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  ForgotPasswordState get initialState => ForgotPasswordFormState.empty();

  @override
  Stream<ForgotPasswordState> transformEvents(
    Stream<ForgotPasswordEvent> events,
    Stream<ForgotPasswordState> Function(ForgotPasswordEvent event) next,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged &&
          event is! PasswordOneChanged &&
          event is! PasswordTwoChanged &&
          event is! TokenChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged ||
          event is PasswordOneChanged ||
          event is PasswordTwoChanged ||
          event is TokenChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<ForgotPasswordState> mapEventToState(
      ForgotPasswordEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordOneChanged) {
      yield* _mapPasswordOneChangedToState(event.password);
    } else if (event is PasswordTwoChanged) {
      yield* _mapPasswordTwoChangedToState(event.password1, event.password2);
    } else if (event is TokenChanged) {
      yield* _mapTokenChangedEventToState(event.token);
    } else if (event is SendPasswordResetEmail) {
      yield* _mapSendPasswordResetEmailToState(event.email);
    } else if (event is SaveNewPassword) {
      yield* _mapSavePasswordToState(
          event.email, event.token, event.newPassword);
    }
  }

  Stream<ForgotPasswordState> _mapEmailChangedToState(String email) async* {
    yield (state as ForgotPasswordFormState).update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<ForgotPasswordState> _mapPasswordOneChangedToState(
      String password) async* {
    yield (state as ForgotPasswordFormState).update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<ForgotPasswordState> _mapPasswordTwoChangedToState(
      String password1, String password2) async* {
    yield (state as ForgotPasswordFormState).update(
      isPasswordsMatch: await Validators.isPasswordsMatch(password1, password2),
    );
  }

  Stream<ForgotPasswordState> _mapTokenChangedEventToState(
      String token) async* {
    yield (state as ForgotPasswordFormState)
        .update(isTokenValid: await Validators.isTokenValid(token));
  }

  Stream<ForgotPasswordState> _mapSendPasswordResetEmailToState(
      String email) async* {
    try {
      yield ForgotPasswordFormState.sendingEmail();
      await _userRepository.resetPassword(email);
      yield ForgotPasswordFormState.emailSent();
      yield ForgotPasswordFormState.empty();
    } catch (e) {
      yield ForgotPasswordError(error: e);
    }
  }

  Stream<ForgotPasswordState> _mapSavePasswordToState(
      String email, String token, String newPassword) async* {
    try {
      yield ForgotPasswordFormState.loading();
      await _userRepository.confirmReset(email, token, newPassword);
      yield ForgotPasswordFormState.success();
    } catch (e) {
      yield ForgotPasswordError(error: e);
    }
  }
}
