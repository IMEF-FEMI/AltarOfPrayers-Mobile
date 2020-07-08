import 'package:equatable/equatable.dart';

abstract class MyEditionEvent extends Equatable {
  const MyEditionEvent();
  @override
  List<Object> get props => [];
}

class LoadMyEditions extends MyEditionEvent {
  final edition;

  const LoadMyEditions({
    this.edition,
  });
}
