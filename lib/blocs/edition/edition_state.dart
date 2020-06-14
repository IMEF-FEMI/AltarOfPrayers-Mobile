import 'package:altar_of_prayers/models/edition.dart';
import 'package:equatable/equatable.dart';

abstract class EditionState extends Equatable {
  const EditionState();

  @override
  List<Object> get props => [];
}

class EditionLoading extends EditionState {}

class EditionLoaded extends EditionState {
  final EditionPurchase editionPurchase;

  const EditionLoaded(this.editionPurchase);

  @override
  List<Object> get props => [editionPurchase];

  String toString() => 'EditionLoaded { edition: $editionPurchase}';
}

class EditionNotLoaded extends EditionState {}
