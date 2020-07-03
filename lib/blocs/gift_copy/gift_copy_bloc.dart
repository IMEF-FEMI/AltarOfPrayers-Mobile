import 'dart:async';
import 'package:altar_of_prayers/repositories/user_repository.dart';
import 'package:altar_of_prayers/utils/validators.dart';
import './bloc.dart';
import 'package:bloc/bloc.dart';

class GiftCopyBloc extends Bloc<GiftCopyEvent, GiftCopyState> {
  final UserRepository _userRepository = UserRepository();
  @override
  GiftCopyState get initialState => GiftCopyInitial(isEmailValid: true);

  @override
  Stream<GiftCopyState> mapEventToState(
    GiftCopyEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is FindUser) {
      yield* _mapFindUserToState(event.email, event.editionId);
    }
  }

  Stream<GiftCopyState> _mapEmailChangedToState(String email) async* {
    yield (state as GiftCopyInitial)
        .update(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<GiftCopyState> _mapFindUserToState(
      String email, int editionId) async* {
    yield GiftCopyLoading();
    try {
      Map user = await _userRepository.fetchUser(email: email);
      bool alreadyHasACopy = false;
      // loop through both lists to confirm
      // if user already has a copy of the edition
      user["user"]["paidBy"].forEach((editionPurchase) {
        if (int.parse(editionPurchase["edition"]["id"]) == editionId)
          alreadyHasACopy = true;
      });
      user["user"]["paidFor"].forEach((editionPurchase) {
        if (int.parse(editionPurchase["edition"]["id"]) == editionId)
          alreadyHasACopy = true;
      });
      if (alreadyHasACopy) {
        yield UserAlreadyHasACopy();
        return;
      }
      yield UserFound(
          email: user["user"]["email"], fullName: user["user"]["fullname"]);
    } catch (e) {
      print(e);
    }
  }
}
