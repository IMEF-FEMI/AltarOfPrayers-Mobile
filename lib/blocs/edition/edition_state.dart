import 'package:altar_of_prayers/models/edition.dart';
import 'package:equatable/equatable.dart';

abstract class EditionState extends Equatable {
  const EditionState();

  @override
  List<Object> get props => [];
}

class EditionLoading extends EditionState {}

class EditionLoaded extends EditionState {
  final Edition editionPurchase;
  final bool isLoading;

  const EditionLoaded({this.editionPurchase, this.isLoading});

  @override
  List<Object> get props => [editionPurchase, isLoading];

  String toString() => 'EditionLoaded { edition: $editionPurchase}';
}

class EditionNotLoaded extends EditionState {
  final bool isLoading;

  const EditionNotLoaded({this.isLoading});
}

class EditionError extends EditionState {
  final String error;
  final String reference;
  final int editionId;

  const EditionError({this.error, this.reference, this.editionId});
}
