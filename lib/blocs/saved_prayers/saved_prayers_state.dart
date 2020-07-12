import 'package:altar_of_prayers/models/prayer.dart';
import 'package:equatable/equatable.dart';

abstract class SavedPrayersState extends Equatable {
  const SavedPrayersState();

  @override
  List<Object> get props => [];
}

class SavedPrayersLoading extends SavedPrayersState {
  @override
  List<Object> get props => [];
}

class SavedPrayersLoaded extends SavedPrayersState {
  final List<Prayer> prayers;

  const SavedPrayersLoaded({this.prayers});

  @override
  List<Object> get props => [prayers];
}

class SavedPrayersError extends SavedPrayersState {
  final String error;

  const SavedPrayersError({this.error});

  @override
  List<Object> get props => [];
}
