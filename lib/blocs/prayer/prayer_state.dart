import 'package:altar_of_prayers/models/prayer.dart';
import 'package:equatable/equatable.dart';

abstract class PrayerState extends Equatable {
  const PrayerState();

  @override
  List<Object> get props => [];
}

class LoadingPrayer extends PrayerState {}

class PrayerLoaded extends PrayerState {
  final bool showDialog;
  final Prayer prayer;


  const PrayerLoaded({this.prayer, this.showDialog});

  @override
  List<Object> get props => [prayer];
}

class PrayerNotAvailable extends PrayerState {}

class ShowMakePaymentScreen extends PrayerState {
  final edition;

  const ShowMakePaymentScreen({this.edition});
}


class PrayerError extends PrayerState {
  final String error;

  const PrayerError(this.error);

  @override
  List<Object> get props => [error];
}
