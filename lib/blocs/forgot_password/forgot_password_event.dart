import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends ForgotPasswordEvent {
  final String email;

  EmailChanged({@required this.email});
}

class PasswordOneChanged extends ForgotPasswordEvent {
  final String password;

  const PasswordOneChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordOneChanged { password: $password }';
}

class PasswordTwoChanged extends ForgotPasswordEvent {
  final String password1;
  final String password2;

  const PasswordTwoChanged(
      {@required this.password1, @required this.password2});

  @override
  List<Object> get props => [password1, password2];

  @override
  String toString() => 'PasswordTwoChanged { password2: $password2 }';
}

class TokenChanged extends ForgotPasswordEvent {
  final String token;

  TokenChanged({@required this.token});

  @override
  List<Object> get props => [token];
}

class SendPasswordResetEmail extends ForgotPasswordEvent {
  final String email;

  const SendPasswordResetEmail({@required this.email});

  @override
  List<Object> get props => [email];
}

class SaveNewPassword extends ForgotPasswordEvent {
  final String email;
  final String token;
  final String newPassword;

  const SaveNewPassword({
    @required this.email,
    @required this.token,
    @required this.newPassword,
  });

  @override
  List<Object> get props => [email, token, newPassword];
}
