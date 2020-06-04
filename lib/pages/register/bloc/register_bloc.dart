
import 'package:altar_of_prayers/repositories/user_repository.dart';
import 'package:altar_of_prayers/utils/validators.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<RegisterState> transformEvents(
    Stream<RegisterEvent> events,
    Stream<RegisterState> Function(RegisterEvent event) next,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged &&
          event is! PasswordOneChanged &&
          event is! PasswordTwoChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged ||
          event is PasswordOneChanged ||
          event is PasswordTwoChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordOneChanged) {
      yield* _mapPasswordOneChangedToState(event.password);
    } else if (event is PasswordTwoChanged) {
      yield* _mapPasswordTwoChangedToState(event.password1, event.password2);
    } else if (event is RegisterWithCredentialsPressed) {
      yield* _mapRegisterWithCredentialsToState(
          event.name, event.email, event.password, event.accountType);
    } else if (event is RegisterWithGooglePressed) {
      yield* _mapRegisterWithGooglePressedToState();
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapPasswordOneChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapPasswordTwoChangedToState(
      String password1, String password2) async* {
    yield state.update(
      isPasswordsMatch: await Validators.isPasswordsMatch(password1, password2),
    );
  }

  Stream<RegisterState> _mapRegisterWithCredentialsToState(
    String name,
    String email,
    String password,
    String accountType,
  ) async* {
    yield RegisterState.loading();
    try {
     await _userRepository.signUp(
          name: name,
          email: email,
          password: password,
          accountType: accountType);
          // print("user after registration ${user.toDatabaseJson()}");
      yield RegisterState.success();
      // yield RegisterState.failure(error: "Success");
    } catch (e) {
      print("Error: $e");
      yield RegisterState.failure(error: (e.toString()));
      
    }
  }

  Stream<RegisterState> _mapRegisterWithGooglePressedToState() async* {
    try {
      yield RegisterState.googleLoading();
      await _userRepository.signUpWithGoogle();
      yield RegisterState.success();
    } catch (e) {
     yield RegisterState.failure(error: (e.toString()));
    }
  }
}
