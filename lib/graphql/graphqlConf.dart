import 'package:altar_of_prayers/models/user.dart';
import 'package:altar_of_prayers/repositories/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfiguration {
  // static HttpLink httpLink = HttpLink(
  //   uri: "http://192.168.137.1:8000/graphql/",
  // );

  static HttpLink httpLink = HttpLink(
    uri: "http://192.168.43.74:8000/graphql/",
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
    link: httpLink,
    cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
  ));

  Future<GraphQLClient> clientToQuery() async {
  UserRepository _userRepository = UserRepository();

    // if user is signed in, httpLink = httplink with header
    // to enable general acccess
    User user = await _userRepository.getUser();
    AuthLink aLink = AuthLink(
      getToken: () => user != null ? 'JWT ${user.token}' : '',
    );
    return GraphQLClient(
        link: aLink.concat(httpLink),
        // link: (httpLink),
        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject));
  }
}
