import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class GiftCopyEvent extends Equatable {
  const GiftCopyEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends GiftCopyEvent {
  final String email;

  const EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class FindUser extends GiftCopyEvent {
  final String email;
  final int editionId;

  const FindUser({
    @required this.email,
    @required this.editionId,
  });

  @override
  List<Object> get props => [email, editionId];
}

class InviteUser extends GiftCopyEvent {
  final String email;

  const InviteUser({
    @required this.email,
  });
}
