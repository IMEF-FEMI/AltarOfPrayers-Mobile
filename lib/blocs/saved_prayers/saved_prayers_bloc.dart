import 'dart:async';

import 'package:altar_of_prayers/models/prayer.dart';
import 'package:altar_of_prayers/repositories/prayer_repository.dart';
import 'package:bloc/bloc.dart';

import 'bloc.dart';

class SavedPrayersBloc extends Bloc<SavedPrayersEvent, SavedPrayersState> {
  final PrayerRepository _prayerRepository = PrayerRepository();
  @override
  SavedPrayersState get initialState => SavedPrayersLoading();

  @override
  Stream<SavedPrayersState> mapEventToState(
    SavedPrayersEvent event,
  ) async* {
    if (event is LoadSavedPrayers) {
      yield* _mapLoadSavedPrayersoState(event);
    } else if (event is RemovePrayer) {
      yield* _mapRemovePrayerToState(event);
    } else if (event is DeletePrayer) {
      yield* _mapDeletePrayerToState(event);
    } else if (event is UndoRemove) {
      yield* _mapUndoRemoveToState(event);
    }
  }

  Stream<SavedPrayersState> _mapLoadSavedPrayersoState(
      LoadSavedPrayers event) async* {
    List _prayers = await _prayerRepository.getPrayers();
    
    yield SavedPrayersLoaded(
      prayers: _prayers.map((prayer) => Prayer.fromDatabaseJson(prayer)).toList(),
    );
  }

  Stream<SavedPrayersState> _mapRemovePrayerToState(RemovePrayer event) async* {
    List<Prayer> _prayers = (state as SavedPrayersLoaded)
        .prayers
        .where((prayer) => prayer.id != event.prayer.id)
        .toList();

    yield SavedPrayersLoaded(prayers: _prayers);
  }

  Stream<SavedPrayersState> _mapUndoRemoveToState(UndoRemove event) async* {
    List<Prayer> _prayers = (state as SavedPrayersLoaded).prayers;
    _prayers.insert(event.index, event.prayer);
    print(_prayers.length);
    yield SavedPrayersLoading();
    yield SavedPrayersLoaded(prayers: _prayers);
  }

  Stream<SavedPrayersState> _mapDeletePrayerToState(DeletePrayer event) async* {
    await _prayerRepository.deletePrayer(id: event.prayer.id);
    List<Prayer> _prayers = (state as SavedPrayersLoaded)
        .prayers
        .where((prayer) => prayer.id != event.prayer.id)
        .toList();

    yield SavedPrayersLoaded(prayers: _prayers);
  }
}
