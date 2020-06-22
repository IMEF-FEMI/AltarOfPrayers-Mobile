import 'package:altar_of_prayers/blocs/make_payment/bloc.dart';
import 'package:altar_of_prayers/models/edition.dart';
import 'package:altar_of_prayers/repositories/edition_repository.dart';
import 'package:bloc/bloc.dart';

class MakePaymentBloc extends Bloc<MakePaymentEvent, MakePaymentState> {
  final EditionsRepository _editionsRepository = EditionsRepository();

  @override
  MakePaymentState get initialState => PaymentLoading();

  @override
  Stream<MakePaymentState> mapEventToState(MakePaymentEvent event) async* {
    if (event is CheckForIncompleteTransactions) {
      yield* _mapCheckForIcompleteTransactionsToState(event);
    } else if (event is CompleteTransaction) {
      yield* _mapCompleteTransactionToState(event);
    }
  }

  Stream<MakePaymentState> _mapCheckForIcompleteTransactionsToState(
      CheckForIncompleteTransactions event) async* {
    yield PaymentLoading();
    print('Checking to see if an incomplete transaction exists');
    var ref =
        await _editionsRepository.getReference(editionId: event.editionId);

    if (ref != null) {
      print('an incomplete transaction exists');

      this.add(CompleteTransaction(
        editionId: event.editionId,
        reference: ref['reference'],
      ));
    } else {
    print('no incomplete transaction exists');

      yield ShowPaymentScreen();
    }
  }

  Stream<MakePaymentState> _mapCompleteTransactionToState(
      CompleteTransaction event) async* {
    yield PaymentLoading();
    yield* confirmPayment(event);
  }

  Stream<MakePaymentState> confirmPayment(CompleteTransaction event) async* {
    try {
      Edition edition = await _editionsRepository.confirmPayment(
          editionId: event.editionId,
          reference: event.reference,
          paidFor: event.paidFor == null ? 'self' : event.paidFor);
      if (edition == null) {
        // delete reference from db
        await _editionsRepository.deleteReference(editionId: event.editionId);
        yield PaymentFailed(
          error: 'Transaction Failed',
          editionId: event.editionId,
          reference: event.reference,
        );
        return;
      }
      await _editionsRepository.deleteReference(editionId: event.editionId);
      yield PaymentSuccessful(edition: edition);
    } catch (e) {
      // await _editionsRepository.deleteReference(editionId: event.editionId);
      yield PaymentFailed(
        error: 'Server error! Hit the Button below to complete your payment',
        editionId: event.editionId,
        reference: event.reference,
      );
      return;
    }
  }
}
