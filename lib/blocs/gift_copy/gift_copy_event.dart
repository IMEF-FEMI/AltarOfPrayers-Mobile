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