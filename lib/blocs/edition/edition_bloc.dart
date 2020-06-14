import 'package:altar_of_prayers/blocs/edition/bloc.dart';
import 'package:bloc/bloc.dart';

class EditionBloc extends Bloc<EditionEvent, EditionState> {
  @override
  EditionState get initialState => EditionLoading();

  @override
  Stream<EditionState> mapEventToState(EditionEvent event) async* {
    if (event is LoadEdition) {
      yield* _mapLoadEditionToState(event);
    }
    else if(event is TransactionComplete){
      yield* _mapTransactionCompleteToState(event);
    }
  }

  Stream _mapLoadEditionToState(LoadEdition event) async* {
    yield EditionLoading();
  }
  Stream _mapTransactionCompleteToState(TransactionComplete event){
    
  }
}
