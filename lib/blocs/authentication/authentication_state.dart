import 'package:altar_of_prayers/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable{
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState{}

class Authenticated extends AuthenticationState{
  final User user;

  const Authenticated(this.user);

  @override
  List<Object> get props => [user];
  
  @override
  String toString() => 'Authenticated';
  // String toString() => 'Authenticated { userName: $user.userName }';
}

class UnAuthenticated extends AuthenticationState{}
