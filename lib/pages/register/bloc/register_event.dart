import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends RegisterEvent {
  final String name;

  const NameChanged({@required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'EmailChanged { name :$name }';
}

class EmailChanged extends RegisterEvent {
  final String email;

  const EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordOneChanged extends RegisterEvent {
  final String password;

  const PasswordOneChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordOneChanged { password: $password }';
}

class PasswordTwoChanged extends RegisterEvent {
  final String password1;
  final String password2;

  const PasswordTwoChanged(
      {@required this.password1, @required this.password2});

  @override
  List<Object> get props => [password1, password2];

  @override
  String toString() => 'PasswordTwoChanged { password2: $password2 }';
}


class RegisterWithGooglePressed extends RegisterEvent {}

class RegisterWithCredentialsPressed extends RegisterEvent {
  final String name;
  final String email;
  final String password;
  final String accountType;

  const RegisterWithCredentialsPressed(
      {@required this.name,
      @required this.email,
      @required this.password,
      @required this.accountType});

  @override
  List<Object> get props => [name, email, password, accountType];

  @override
  String toString() {
    return 'RegisterWithCredentialsPressed {firstName: $name, email: $email, password: $password, accountType: $accountType }';
  }
}
