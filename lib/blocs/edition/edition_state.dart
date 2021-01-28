import 'package:altar_of_prayers/models/edition.dart';
import 'package:equatable/equatable.dart';

abstract class EditionState extends Equatable {
  const EditionState();

  @override
  List<Object> get props => [];
}

class EditionLoading extends EditionState {}

class EditionLoaded extends EditionState {
  final Edition edition;
  final bool isLoading;
  final bool showDialog;

  const EditionLoaded({this.showDialog, this.edition, this.isLoading});

  @override
  List<Object> get props => [edition, isLoading];

  String toString() => 'EditionLoaded { edition: $edition}';
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

