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

  GraphQLClient clientToQuery({String token}) {
    // if user is signed in, httpLink = httplink with header
    // to enable general acccess

    if (token != null) {
      httpLink = HttpLink(
          uri: "http://192.168.43.74:8000/graphql/",
          headers: {'AUTHORIZATION': 'JWT $token'});
    }
    return GraphQLClient(
        link: httpLink,
        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject));
  }
}
