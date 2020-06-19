import 'dart:async';

import 'package:altar_of_prayers/blocs/new_editions/bloc.dart';
import 'package:altar_of_prayers/repositories/edition_repository.dart';
import 'package:bloc/bloc.dart';

class NewEditionsBloc extends Bloc<NewEditionsEvent, NewEditionsState> {
  EditionsRepository editionsRepository = EditionsRepository();
  @override
  NewEditionsState get initialState => NewEditionsState.loading();

  @override
  Stream<NewEditionsState> mapEventToState(NewEditionsEvent event) async* {
    if (event is ReFreshEvent) {
      yield NewEditionsState.loading();
      try {
        Map seenEditions = await editionsRepository.getSeenEditions();
        List editions = await editionsRepository.getPublishedEditions();
        yield NewEditionsState(
          editions: editions,
          isLoading: false,
          isFailure: false,
          seenEditions: seenEditions,
        );
      } catch (e) {
        yield NewEditionsState(
            editions: List(),
            isLoading: false,
            isFailure: true,
            seenEditions: {});
      }
    }
  }
}
