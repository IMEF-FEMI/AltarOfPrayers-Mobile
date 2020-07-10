import 'package:altar_of_prayers/blocs/make_payment/bloc.dart';
import 'package:altar_of_prayers/models/edition.dart';
import 'package:altar_of_prayers/models/user.dart';
import 'package:altar_of_prayers/repositories/edition_repository.dart';
import 'package:altar_of_prayers/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';

class MakePaymentBloc extends Bloc<MakePaymentEvent, MakePaymentState> {
  final EditionsRepository _editionsRepository = EditionsRepository();
  final UserRepository _userRepository = UserRepository();

  @override
  MakePaymentState get initialState => PaymentLoading();

  @override
  Stream<MakePaymentState> mapEventToState(MakePaymentEvent event) async* {
    if (event is CheckForIncompleteTransactions) {
      yield* _mapCheckForIcompleteTransactionsToState(event);
    } else if (event is CompleteTransaction) {
      yield* _mapCompleteTransactionToState(event);
    } else if (event is GetUserInfo) {
      yield* _mapGetUserInfoToState(event);
    }
  }

  Stream<MakePaymentState> _mapGetUserInfoToState(GetUserInfo event) async* {
    yield ShowPaymentScreen(showLoadingDialog: true);
    try {
      Map currentUserInfo = await _userRepository.currentUserInfo();
      User user = User(
        id: currentUserInfo["currentUser"]['id'],
        email: currentUserInfo["currentUser"]['email'],
        fullName: currentUserInfo["currentUser"]['fullname'],
        accountType: currentUserInfo["currentUser"]['accountType'],
        token: 'token',
        staff: currentUserInfo["currentUser"]['staff'],
        admin: currentUserInfo["currentUser"]['admin'],
        isVerified: currentUserInfo["currentUser"]['isVerified'],
      );
      if (user.isVerified == false)
        await _userRepository.resendConfirmationEmail(email: user.email);
      yield LoadUserInfo(user: user);
      // yield ShowPaymentScreen(showLoadingDialog: false);
    } catch (e) {
      yield LoadUserInfo();
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

      yield ShowPaymentScreen(showLoadingDialog: false);
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
      yield PaymentSuccessful(
        edition: edition,
      );
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
