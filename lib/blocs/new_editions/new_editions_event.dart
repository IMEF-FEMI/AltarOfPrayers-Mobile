import 'package:equatable/equatable.dart';

abstract class NewEditionsEvent extends Equatable {
  const NewEditionsEvent();

  @override
  List<Object> get props => [];
}

class ReFreshEvent extends NewEditionsEvent {
  const ReFreshEvent();

  @override
  String toString() => 'Refresh Event';
}
