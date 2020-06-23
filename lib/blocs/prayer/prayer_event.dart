import 'package:altar_of_prayers/models/prayer.dart';
import 'package:equatable/equatable.dart';

abstract class PrayerEvent extends Equatable {
  const PrayerEvent();

  @override
  List<Object> get props => [];
}

class LoadPrayer extends PrayerEvent {
  final int year;
  final int month;
  final int day;
  final bool showDialog;

  const LoadPrayer({this.year, this.month, this.day, this.showDialog});
}

class SavePrayer extends PrayerEvent {
  final Prayer prayer;

  const SavePrayer(this.prayer);
}

class UnsavePrayer extends PrayerEvent {
  final Prayer prayer;

  const UnsavePrayer(this.prayer);
}
