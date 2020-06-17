import 'package:altar_of_prayers/models/edition.dart';
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

class CompleteTransaction extends EditionEvent {
  final int editionId;
  final String reference;

  const CompleteTransaction({this.editionId, this.reference});
}

class UpdateEdition extends EditionEvent {
  final Edition editionPurchase;

  const UpdateEdition(this.editionPurchase);
}
