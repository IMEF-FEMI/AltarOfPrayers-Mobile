import 'dart:async';
import 'package:altar_of_prayers/blocs/edition/bloc.dart';
import 'package:altar_of_prayers/blocs/make_payment/bloc.dart';
import 'package:altar_of_prayers/models/edition.dart';
import 'package:altar_of_prayers/repositories/edition_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class EditionBloc extends Bloc<EditionEvent, EditionState> {
  final EditionsRepository editionsRepository;
  final MakePaymentBloc makePaymentBloc;
  StreamSubscription subscription;

  EditionBloc(
      {@required this.editionsRepository, @required this.makePaymentBloc}) {
    if (makePaymentBloc == null) return;
    subscription = makePaymentBloc.listen((makePaymentState)  {
      if (makePaymentState is PaymentSuccessful) {
        print('payment successful');
        add(LoadEdition(edition:{
          "id": makePaymentState.edition.id,
          "published": true,
          "name": makePaymentState.edition.name,
          "startingMonth": makePaymentState.edition.startingMonth,
          "year": makePaymentState.edition.year,
          "paid": true
        }, showDialog: true));
        return;
      }
    });
  }
  @override
  EditionState get initialState => EditionLoading();
  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }

  @override
  Stream<EditionState> mapEventToState(EditionEvent event) async* {
    if (event is LoadEdition) {
      yield* _mapLoadEditionToState(event);
    }
  }

  Stream<EditionState> _mapLoadEditionToState(LoadEdition event) async* {
    // load edition here
    // if edition exists, return it
    // else return editionnotLoaded state
    // which push the make payment screen route
    // the make payment screen goes ahead to check
    // if theres and incomplete payment first
    // and then renders appropriately
    yield EditionLoading();
    try {
      await editionsRepository.saveSeenEdition(editionId: event.edition['id']);

      Edition edition =
          await editionsRepository.getEdition(editionId: event.edition['id']);

      if (edition != null) {
        yield EditionLoaded(
            edition: edition, isLoading: false, showDialog: event.showDialog);
      } else {
        yield EditionNotLoaded(
          isLoading: false,
        );
      }
    } catch (e) {
      print(e);
      yield EditionError(
          editionId: event.edition['id'], error: 'Opps! an error occured');
    }
    return;
  }
}
