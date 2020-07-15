import 'package:equatable/equatable.dart';

abstract class MainScreenState extends Equatable {
  const MainScreenState();
  @override
  List<Object> get props => [];
}

class MainScreenInitial extends MainScreenState {
  final int badgeCount;

  MainScreenInitial({this.badgeCount});

  @override
  List<Object> get props => [badgeCount];
}
