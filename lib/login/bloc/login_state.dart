import 'package:meta/meta.dart';

@immutable
class LoginState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isGoogleAccount;
  final bool isSuccess;
  final bool isFailure;
  final String error;

  bool get isFormValid =>
      
      isEmailValid &&
      isPasswordValid ;

  String get errorMessage => error;
  
  LoginState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isSubmitting,
    @required this.isGoogleAccount,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.error,
  });

  factory LoginState.empty() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isGoogleAccount: false,
      isSuccess: false,
      isFailure: false,
      error: "",
    );
  }

  factory LoginState.loading() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: true,
      isGoogleAccount: false,
      isSuccess: false,
      isFailure: false,
      error: "",
    );
  }

    factory LoginState.googleLoading() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: true,
      isGoogleAccount: true,
      isSuccess: false,
      isFailure: false,
      error: "",
    );
  }
  factory LoginState.failure({String error}) {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
        isGoogleAccount: false,
      isSuccess: false,
      isFailure: true,
      error: error
    );
  }

  factory LoginState.success() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isGoogleAccount: false,
      isSuccess: true,
      isFailure: false,
      error: "",
    );
  }

  LoginState update(
      {
      bool isNameNotEmpty,
      bool isEmailValid,
      bool isPasswordValid,
      bool isPasswordsMatch,
      String error,}) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isGoogleAccount: false,
      isSuccess: false,
      isFailure: false,
      error: error,
    );
  }

  LoginState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitting,
    bool isGoogleAccount,
    bool isSuccess,
    bool isFailure,
    String error,
  }) {
    return LoginState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isGoogleAccount: isGoogleAccount ?? this.isGoogleAccount,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      error: error ?? this.error,
    );
  }

}
