import 'package:altar_of_prayers/models/prayer.dart';
import 'package:equatable/equatable.dart';

abstract class SavedPrayersEvent extends Equatable {
  const SavedPrayersEvent();
  @override
  List<Object> get props => [];
}

class LoadSavedPrayers extends SavedPrayersEvent {}

class RemovePrayer extends SavedPrayersEvent {
  final Prayer prayer;
  final int index;

  const RemovePrayer({this.prayer, this.index});
}

class UndoRemove extends SavedPrayersEvent {
  final Prayer prayer;
  final int index;

  const UndoRemove({this.prayer, this.index});
}

class DeletePrayer extends SavedPrayersEvent {
  final Prayer prayer;

  const DeletePrayer({this.prayer});
}
