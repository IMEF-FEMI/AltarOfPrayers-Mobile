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

class TransactionComplete extends EditionEvent{
  final String reference;

  const TransactionComplete(this.reference);
}

class UpdateEdition extends EditionEvent {
  final EditionPurchase editionPurchase;

  const UpdateEdition(this.editionPurchase);
}
