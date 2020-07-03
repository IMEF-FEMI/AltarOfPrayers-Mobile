import 'dart:async';

import 'package:altar_of_prayers/utils/validators.dart';

import './bloc.dart';
import 'package:bloc/bloc.dart';

class GiftCopyBloc extends Bloc<GiftCopyEvent, GiftCopyState> {
  @override
  GiftCopyState get initialState => GiftCopyInitial(isEmailValid: true);

  @override
  Stream<GiftCopyState> mapEventToState(
    GiftCopyEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    }
  }

  Stream<GiftCopyState> _mapEmailChangedToState(String email) async* {
    yield (state as GiftCopyInitial)
        .update(isEmailValid: Validators.isValidEmail(email));
  }
}
