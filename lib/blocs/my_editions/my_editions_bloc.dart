import 'package:altar_of_prayers/blocs/my_editions/bloc.dart';
import 'package:altar_of_prayers/repositories/edition_repository.dart';
import 'package:bloc/bloc.dart';

class MyEditionsBloc extends Bloc<MyEditionEvent, MyEditionsState> {
  final EditionsRepository editionsRepository = EditionsRepository();


  @override
  MyEditionsState get initialState => LoadingMyEditions();

  @override
  Stream<MyEditionsState> mapEventToState(MyEditionEvent event) async* {
    if (event is LoadMyEditions) {
      yield LoadingMyEditions();
      
    }
  }
}
