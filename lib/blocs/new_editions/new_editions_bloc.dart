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
    if (event is LoadEditions) {
      if (state.editions.length == 0) yield NewEditionsState.loading();
      try {
        Map seenEditions = await editionsRepository.getSeenEditions();
        print("We here");
        List editions = await editionsRepository.getPublishedEditions();
        yield NewEditionsState(
          editions: editions,
          isLoading: false,
          isFailure: false,
          seenEditions: seenEditions,
        );
      } catch (e) {
        yield NewEditionsState.isFailure();
      }
    }
  }
}
