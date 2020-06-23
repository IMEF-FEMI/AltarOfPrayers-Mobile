import 'package:equatable/equatable.dart';

abstract class EditionEvent extends Equatable {
  const EditionEvent();
  @override
  List<Object> get props => [];
}

class LoadEdition extends EditionEvent {
  final edition;
  final bool showDialog;

  const LoadEdition({this.edition, this.showDialog});
}
