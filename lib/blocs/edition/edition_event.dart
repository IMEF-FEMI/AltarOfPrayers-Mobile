import 'package:equatable/equatable.dart';

abstract class EditionEvent extends Equatable {
  const EditionEvent();
  @override
  List<Object> get props => [];
}

class LoadEdition extends EditionEvent {
  final edition;

  const LoadEdition(this.edition);
}
