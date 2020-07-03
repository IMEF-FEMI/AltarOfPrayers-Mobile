import 'package:meta/meta.dart';

class NewEditionsState {
  final bool isLoading;
  final bool isFailure;
  final Map seenEditions;
  final List editions;

  NewEditionsState(
      {@required this.seenEditions,
      @required this.isLoading,
      @required this.editions,
      @required this.isFailure});

  factory NewEditionsState.loading() {
    return NewEditionsState(
        isLoading: true, editions: [], isFailure: false, seenEditions: {});
  }
  factory NewEditionsState.isFailure() {
    return NewEditionsState(
        isLoading: false, editions: [], isFailure: true, seenEditions: {});
  }
  @override
  String toString() =>
      'isLoading: $isLoading, editions: $editions, isFailure: $isFailure';
  // factory NewEditionsState.update({bool isLoading, List editions, String error}) {

  //   return copyWith(bool isLoading, List editions, String error);
  // }

  // NewEditionsState copyWith({bool isLoading, List editions, String error}){
  //    return NewEditionsState(
  //     isLoading: isLoading ?? this.isLoading,
  //     editions: editions ?? this.editions,
  //     error: error ?? this.error,
  //   );
  // }
}
