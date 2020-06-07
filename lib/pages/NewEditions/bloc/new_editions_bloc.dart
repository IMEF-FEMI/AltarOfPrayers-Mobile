import 'dart:async';

import 'package:altar_of_prayers/pages/NewEditions/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
class NewEditionsBloc extends Bloc<NewEditionsEvent, NewEditionsState>{
  
  @override
  NewEditionsState get initialState => NewEditionsState.loading();

  @override
  Stream<NewEditionsState> mapEventToState(NewEditionsEvent event)async* {
    if (event is ReFreshEvent) {
      yield NewEditionsState.loading();
    }
  }
} 