import 'package:meta/meta.dart';

class NewEditionsState {
  final bool isLoading;
  final List editions;
  final String error;

  NewEditionsState(
      {@required this.isLoading,
      @required this.editions,
      @required this.error});

  factory NewEditionsState.loading() {
    return NewEditionsState(isLoading: true, editions: [], error: '');
  }

  NewEditionsState update({bool isLoading, List editions, String error}) {
    return NewEditionsState(
      isLoading: isLoading ?? this.isLoading,
      editions: editions ?? this.editions,
      error: error ?? this.error,
    );
  }
}
