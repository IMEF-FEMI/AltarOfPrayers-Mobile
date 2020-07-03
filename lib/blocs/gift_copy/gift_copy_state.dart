import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class GiftCopyState extends Equatable {
  const GiftCopyState();

  @override
  List<Object> get props => [];
}

class GiftCopyInitial extends GiftCopyState {
  final bool isEmailValid;

  const GiftCopyInitial({this.isEmailValid});

  GiftCopyInitial update({bool isEmailValid}) {
    return GiftCopyInitial(isEmailValid: isEmailValid ?? this.isEmailValid);
  }

  @override
  List<Object> get props => [isEmailValid];
}

class GiftCopyLoading extends GiftCopyState {}

class UserFound extends GiftCopyState {
  final String fullName;
  final String email;

  const UserFound({@required this.fullName, @required this.email});

  @override
  List<Object> get props => [fullName, email];
}

class UserNotFound extends GiftCopyState {}

class Error extends GiftCopyState {
  final String error;

  const Error({@required this.error});
}
