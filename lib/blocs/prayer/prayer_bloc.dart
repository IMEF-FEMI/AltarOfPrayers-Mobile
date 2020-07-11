import 'dart:async';
import 'dart:convert';

import 'package:altar_of_prayers/blocs/make_payment/bloc.dart';
import 'package:altar_of_prayers/blocs/prayer/bloc.dart';
import 'package:altar_of_prayers/models/edition.dart';
import 'package:altar_of_prayers/models/prayer.dart';
import 'package:altar_of_prayers/repositories/edition_repository.dart';
import 'package:altar_of_prayers/repositories/prayer_repository.dart';
import 'package:bloc/bloc.dart';

class PrayerBloc extends Bloc<PrayerEvent, PrayerState> {
  EditionsRepository _editionsRepository = EditionsRepository();
  PrayerRepository _prayerRepository = PrayerRepository();

  final MakePaymentBloc makePaymentBloc;
  StreamSubscription _subscription;

  PrayerBloc({this.makePaymentBloc}) {
    if (makePaymentBloc == null) return;
    _subscription = makePaymentBloc.listen((makePaymentState) {
      if (makePaymentState is PaymentSuccessful) {
        DateTime today = DateTime.now().toUtc();
        this.add(LoadPrayer(
            year: today.year,
            month: today.month,
            day: today.day,
            showDialog: true));
      }
    });
  }

  @override
  get initialState => LoadingPrayer();

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  @override
  Stream<PrayerState> mapEventToState(PrayerEvent event) async* {
    if (event is LoadPrayer) {
      yield* _mapLoadPrayerToState(event);
    } else if (event is SavePrayer) {
      await _prayerRepository.savePrayer(prayer: event.prayer);
      yield PrayerLoaded(prayer: event.prayer, saved: true);
    } else if (event is UnsavePrayer) {
      await _prayerRepository.deletePrayer(id: event.prayer.id);
      yield PrayerLoaded(prayer: event.prayer, saved: false);
    }
  }

  Map<String, dynamic> checkIfEditionAvailable(
      List edition, int startingMonth, int year) {
    bool isAvailable = false;
    Map editionMap;
    edition.forEach(
      (editionStr) {
        Map editionObj = JsonDecoder().convert(editionStr);
        if (startingMonth == editionObj['startingMonth'] &&
            year == editionObj['year']) {
          isAvailable = true;
          editionMap = editionObj;
        }
      },
    );
    if (isAvailable) return {'available': isAvailable, 'edition': editionMap};
    return {'available': isAvailable};
  }

  Stream<PrayerState> _mapLoadPrayerToState(LoadPrayer event) async* {
    yield LoadingPrayer();
    int startingMonth;
    int day = event.day;
    int month = event.month;
    int year = event.year;

    if (month == 1 || month == 2 || month == 3) startingMonth = 1;
    if (month == 4 || month == 5 || month == 6) startingMonth = 4;
    if (month == 7 || month == 8 || month == 9) startingMonth = 7;
    if (month == 10 || month == 11 || month == 12) startingMonth = 10;

    try {
      // get Prayer
      Edition edition = await _editionsRepository.getEdition(
          startingMonth: startingMonth, year: year);

      if (edition == null) {
        // print('That edition hasn\'t been paid for yet');
        // if edition returns null check if that edition exists,
        // if it does, display make payment page else
        // show not available screen
        final editionList = await _editionsRepository.getPublishedEditions();
        Map available =
            checkIfEditionAvailable(editionList, startingMonth, year);
        if (available['available']) {
          yield ShowMakePaymentScreen(edition: available['edition']);
        } else {
          yield PrayerNotAvailable();
        }
        return;
      }

      int prayerMonthInt = month - startingMonth;
      List prayerMonthList = [];
      if (prayerMonthInt == 0) prayerMonthList = edition.monthOne;
      if (prayerMonthInt == 1) prayerMonthList = edition.monthTwo;
      if (prayerMonthInt == 2) prayerMonthList = edition.monthThree;

      Map prayerJson = JsonDecoder().convert(prayerMonthList[day]);
      Prayer prayer = Prayer(
          id: int.parse("$year$month$day"),
          topic: prayerJson["topic"],
          passage: prayerJson["passage"],
          message: prayerJson["message"],
          prayerPoints: prayerJson["prayerPoints"]);
      // check if prayer has been saved
      var savedPrayer = await _prayerRepository.getPrayer(id: prayer.id);
      yield PrayerLoaded(
          prayer: prayer,
          showDialog: event.showDialog,
          saved: savedPrayer != null);
    } catch (e) {
      print(e);
      yield PrayerError('Oops! an error occured');
    }
  }
}
