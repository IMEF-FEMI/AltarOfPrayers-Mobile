import 'package:altar_of_prayers/blocs/my_editions/bloc.dart';
import 'package:altar_of_prayers/models/edition.dart';
import 'package:altar_of_prayers/repositories/edition_repository.dart';
import 'package:altar_of_prayers/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';

class MyEditionsBloc extends Bloc<MyEditionEvent, MyEditionsState> {
  final EditionsRepository editionsRepository = EditionsRepository();

  @override
  MyEditionsState get initialState => LoadingMyEditions();

  @override
  Stream<MyEditionsState> mapEventToState(MyEditionEvent event) async* {
    if (event is LoadMyEditions) {
      UserRepository _userRepository = UserRepository();
      List<Map<String, dynamic>> myEditionsListFromServer = List();
      // first get editions saved locally
      // then get edtions associated with current user from server
      yield LoadingMyEditions();
      List localEditions = await editionsRepository.getLocalEditions();
      localEditions = localEditions
          .map((edition) => {
                'id': (edition as Edition).id,
                'published': true,
                'name': (edition as Edition).name,
                'startingMonth': (edition as Edition).startingMonth,
                'year': (edition as Edition).year,
                'paid': true,
              })
          .toList();
      if (localEditions.length != 0)
        yield MyEditionsLoaded(editions: localEditions);

      try {
        Map currentUserInfo = await _userRepository.currentUserInfo();
        (currentUserInfo["currentUser"]["paidFor"] as List).forEach((edition) {
          myEditionsListFromServer.add({
            'id': int.parse(edition["id"]),
            'published': edition["edition"]["published"],
            'name': edition["edition"]["name"],
            'startingMonth': edition["edition"]["startingMonth"],
            'year': edition["edition"]["year"],
            'paid': true,
          });
        });
        if (myEditionsListFromServer.length != 0)
          yield MyEditionsLoaded(editions: myEditionsListFromServer);
      } catch (e) {
        // only show the error if no edition was saved locally
        if (localEditions.length == 0)
          yield MyEditionError(error: "Oops! an error occured");
          return;
      }
      if (localEditions.length == 0 && myEditionsListFromServer.length == 0)
        yield MyEditionsNotLoaded();
    }
  }
}
