import 'package:equatable/equatable.dart';

class MyEditionsState extends Equatable {
  const MyEditionsState();

  @override
  List<Object> get props => [];
}

class LoadingMyEditions extends MyEditionsState {}

class MyEditionsLoaded extends MyEditionsState {
  final List editions;

  const MyEditionsLoaded({this.editions});
}

class MyEditionsNotLoaded extends MyEditionsState {
  final bool isLoading;

  const MyEditionsNotLoaded({this.isLoading});
}

class MyEditionError extends MyEditionsState {
  final String error;

  const MyEditionError({
    this.error,
  });
}
