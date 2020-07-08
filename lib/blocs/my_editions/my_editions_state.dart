import 'package:altar_of_prayers/models/edition.dart';
import 'package:equatable/equatable.dart';

class MyEditionsState extends Equatable {
  const MyEditionsState();

  @override
  List<Object> get props => [];
}

class LoadingMyEditions extends MyEditionsState {}

class MyEditionsLoaded extends MyEditionsState {
  final List<Edition> editions;

  const MyEditionsLoaded({this.editions});
}

class MyEditionNotLoaded extends MyEditionsState {
  final bool isLoading;

  const MyEditionNotLoaded({this.isLoading});
}

class MyEditionError extends MyEditionsState {
  final String error;

  const MyEditionError({
    this.error,
  });
}
