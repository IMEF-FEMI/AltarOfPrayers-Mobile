import 'dart:convert';

import 'package:altar_of_prayers/blocs/edition/bloc.dart';
import 'package:altar_of_prayers/models/edition.dart';
import 'package:altar_of_prayers/repositories/edition_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class EditionBloc extends Bloc<EditionEvent, EditionState> {
  final EditionsRepository _editionsRepository;

  EditionBloc({@required EditionsRepository editionsRepository})
      : assert(editionsRepository != null),
        _editionsRepository = editionsRepository;
  @override
  EditionState get initialState => EditionLoading();

  @override
  Stream<EditionState> mapEventToState(EditionEvent event) async* {
    if (event is LoadEdition) {
      yield* _mapLoadEditionToState(event);
    } else if (event is CompleteTransaction) {
      yield* _mapCompleteTransactionToState(event);
    }
  }

  Stream<EditionState> _mapLoadEditionToState(LoadEdition event) async* {
    // load edition here
    // first check if reference string exists -- in the case of incomplete transactions
    // if reference exists, complete the transaction on backend
    // else getEdition
    yield EditionLoading();
    var ref =
        await _editionsRepository.getReference(editionId: event.edition['id']);
    print('Returned ref from sqflite $ref');
    if (ref != null) {
      this.add(CompleteTransaction(
          editionId: event.edition['id'], reference: ref['reference']));
    } else {
      // EditionPurchase edition = _editionsRepository.getEdition
    }
  }

  Stream<EditionState> _mapCompleteTransactionToState(
      CompleteTransaction event) async* {
    yield EditionLoading();
    if (state is EditionLoaded) {
      yield EditionLoaded(
          editionPurchase: (state as EditionLoaded).editionPurchase,
          isLoading: true);
    } else if (state is EditionNotLoaded) {
      yield EditionNotLoaded(isLoading: true);
    } else {
      try {
        Edition edition = await _editionsRepository.confirmPayment(
            editionId: event.editionId,
            reference: event.reference,
            paidFor: 'self');
        if (edition == null) {
          // delete reference from db
          await _editionsRepository.deleteReference(editionId: event.editionId);
          yield EditionError(
            error: 'transaction error',
            editionId: event.editionId,
            reference: event.reference,
          );
        }
        yield EditionLoaded(editionPurchase: edition, isLoading: false);
      } catch (e) {
        yield EditionError(
          error: 'network error',
          editionId: event.editionId,
          reference: event.reference,
        );
      }
    }
  }
}
