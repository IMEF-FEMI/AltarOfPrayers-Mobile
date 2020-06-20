import 'package:equatable/equatable.dart';

abstract class NewEditionsEvent extends Equatable {
  const NewEditionsEvent();

  @override
  List<Object> get props => [];
}

class LoadEditions extends NewEditionsEvent {
  const LoadEditions();

  @override
  String toString() => 'Refresh Event';
}
