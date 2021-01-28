import 'package:meta/meta.dart';

@immutable
class RegisterState {
  final bool isNameNotEmpty;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isPasswordsMatch;
  final bool isSubmitting;
  final bool isGoogleAccount;
  final bool isSuccess;
  final bool isFailure;
  final String error;

  bool get isFormValid =>
      isNameNotEmpty && isEmailValid && isPasswordValid && isPasswordsMatch;

  String get errorMessage => error;

  RegisterState({
    @required this.isNameNotEmpty,
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isPasswordsMatch,
    @required this.isSubmitting,
    @required this.isGoogleAccount,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.error,
  });

  factory RegisterState.empty() {
    return RegisterState(
      isNameNotEmpty: true,
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordsMatch: true,
      isSubmitting: false,
      isGoogleAccount: false,
      isSuccess: false,
      isFailure: false,
      error: "",
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
      isNameNotEmpty: true,
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordsMatch: true,
      isSubmitting: true,
      isGoogleAccount: false,
      isSuccess: false,
      isFailure: false,
      error: "",
    );
  }

  factory RegisterState.googleLoading() {
    return RegisterState(
      isNameNotEmpty: true,
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordsMatch: true,
      isSubmitting: true,
      isGoogleAccount: true,
      isSuccess: false,
      isFailure: false,
      error: "",
    );
  }
  factory RegisterState.failure({String error}) {
    return RegisterState(
        isNameNotEmpty: true,
        isEmailValid: true,
        isPasswordValid: true,
        isPasswordsMatch: true,
        isSubmitting: false,
        isGoogleAccount: false,
        isSuccess: false,
        isFailure: true,
        error: error);
  }

  factory RegisterState.success() {
    return RegisterState(
      isNameNotEmpty: true,
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordsMatch: true,
      isSubmitting: false,
      isGoogleAccount: false,
      isSuccess: true,
      isFailure: false,
      error: "",
    );
  }

  RegisterState update({
    bool isNameNotEmpty,
    bool isEmailValid,
    bool isPasswordValid,
    bool isPasswordsMatch,
    String error,
  }) {
    return copyWith(
      isNameNotEmpty: isNameNotEmpty,
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isPasswordsMatch: isPasswordsMatch,
      isSubmitting: false,
      isGoogleAccount: false,
      isSuccess: false,
      isFailure: false,
      error: error,
    );
  }

  RegisterState copyWith({
    bool isNameNotEmpty,
    bool isEmailValid,
    bool isPasswordValid,
    bool isPasswordsMatch,
    bool isSubmitting,
    bool isGoogleAccount,
    bool isSuccess,
    bool isFailure,
    String error,
  }) {
    return RegisterState(
      isNameNotEmpty: isNameNotEmpty ?? this.isNameNotEmpty,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isPasswordsMatch: isPasswordsMatch ?? this.isPasswordsMatch,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isGoogleAccount: isGoogleAccount ?? this.isGoogleAccount,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      error: error ?? this.error,
    );
  }

  // @override
  // String toString() {
  //   return '''RegisterState {
  //     isNameNotEmpty: $isNameNotEmpty,
  //     isEmailValid: $isEmailValid,
  //     isPasswordValid: $isPasswordValid,
  //     isSubmitting: $isSubmitting,
  //     isSuccess: $isSuccess,
  //     isFailure: $isFailure,
  //     error: $error
  //   }''';
  // }
}
