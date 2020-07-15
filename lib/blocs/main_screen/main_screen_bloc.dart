import 'dart:async';

import 'package:altar_of_prayers/blocs/main_screen/bloc.dart';
import 'package:altar_of_prayers/blocs/notificaions/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';


class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  final NotificationsBloc notificationsBloc;
  StreamSubscription subscription;

  @override
  get initialState => MainScreenInitial(badgeCount: 0);

  MainScreenBloc({@required this.notificationsBloc}){
    if (notificationsBloc == null) return;
    subscription = notificationsBloc.listen((notificationsState) { 
      if(notificationsState is NotificationsLoaded){
        int badgeCount = 0;
        notificationsState.notifications.forEach((notification) {
          if(!notification.read)
            badgeCount+=1;
         });
        add(SetUnreadBadgeCount(badgeCount: badgeCount));
      }
    });
  }

@override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
  @override
  Stream<MainScreenState> mapEventToState(
    MainScreenEvent event,
  ) async* {
    if (event is SetUnreadBadgeCount){
      yield MainScreenInitial(badgeCount: event.badgeCount);
    }

  }

}
