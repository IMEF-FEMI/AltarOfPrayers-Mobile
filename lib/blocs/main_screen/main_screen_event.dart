import 'package:equatable/equatable.dart';

abstract class MainScreenEvent extends Equatable {
  const MainScreenEvent();

  @override
  List<Object> get props => [];
}

class SetUnreadBadgeCount extends MainScreenEvent {
  final int badgeCount;

  SetUnreadBadgeCount({this.badgeCount});

  @override
  List<Object> get props => [badgeCount];
}
