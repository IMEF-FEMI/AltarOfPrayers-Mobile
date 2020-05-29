import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ForgotPasswordState extends Equatable {
  @override
  List<Object> get props => [];
}

class ForgotPasswordFormState extends ForgotPasswordState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isPasswordsMatch;
  final bool isTokenValid;
  final bool isSendingEmail;
  final bool isEmailSent;
  final bool isSubmitting;
  final bool isSuccess;

  ForgotPasswordFormState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isPasswordsMatch,
    @required this.isTokenValid,
    @required this.isSendingEmail,
    @required this.isEmailSent,
    @required this.isSubmitting,
    @required this.isSuccess,
  });

  bool get isFormValid =>
      isEmailValid && isPasswordValid && isPasswordsMatch && isTokenValid;

  factory ForgotPasswordFormState.empty() {
    return ForgotPasswordFormState(
        isEmailValid: true,
        isPasswordValid: true,
        isPasswordsMatch: true,
        isTokenValid: true,
        isSubmitting: false,
        isSendingEmail: false,
        isEmailSent: false,
        isSuccess: false);
  }

  factory ForgotPasswordFormState.loading() {
    return ForgotPasswordFormState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordsMatch: true,
      isTokenValid: true,
      isSubmitting: true,
      isSendingEmail: false,
      isEmailSent: false,
      isSuccess: false,
    );
  }

  factory ForgotPasswordFormState.success() {
    return ForgotPasswordFormState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordsMatch: true,
      isTokenValid: true,
      isSubmitting: false,
      isSendingEmail: false,
      isEmailSent: false,
      isSuccess: true,
    );
  }

  factory ForgotPasswordFormState.sendingEmail() {
    return ForgotPasswordFormState(
        isEmailValid: true,
        isPasswordValid: true,
        isPasswordsMatch: true,
        isTokenValid: true,
        isSubmitting: false,
        isSendingEmail: true,
        isEmailSent: false,
        isSuccess: false);
  }
  factory ForgotPasswordFormState.emailSent() {
    return ForgotPasswordFormState(
        isEmailValid: true,
        isPasswordValid: true,
        isPasswordsMatch: true,
        isTokenValid: true,
        isSubmitting: false,
        isSendingEmail: false,
        isEmailSent: true,
        isSuccess: false);
  }

  ForgotPasswordFormState update({
    bool isEmailValid,
    bool isPasswordValid,
    bool isPasswordsMatch,
    bool isTokenValid,
    bool isSendingEmail,
    bool isEmailSent,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isPasswordsMatch: isPasswordsMatch,
      isTokenValid: isTokenValid,
      isSendingEmail: isSendingEmail,
      isEmailSent: isEmailSent,
      isSubmitting: false,
      isSuccess: false,
    );
  }

  ForgotPasswordFormState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isPasswordsMatch,
    bool isSendingEmail,
    bool isEmailSent,
    bool isTokenValid,
    bool isSubmitting,
    bool isSuccess,
  }) {
    return ForgotPasswordFormState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isPasswordsMatch: isPasswordsMatch ?? this.isPasswordsMatch,
      isTokenValid: isTokenValid ?? this.isTokenValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSendingEmail: isSendingEmail ?? this.isSendingEmail,
      isEmailSent: isEmailSent ?? this.isEmailSent,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object> get props => [
        isEmailValid,
        isPasswordValid,
        isPasswordsMatch,
        isTokenValid,
        isSubmitting,
        isSendingEmail,
        isEmailSent,
        isSuccess,
      ];
}

class ForgotPasswordError extends ForgotPasswordState {
  final String error;

  ForgotPasswordError({
    this.error,
  });

  @override
  List<Object> get props => [error];
}
