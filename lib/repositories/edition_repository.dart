import 'package:altar_of_prayers/database/editions_dao.dart';
import 'package:altar_of_prayers/graphql/graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EditionsRepository {
  GraphQLConfiguration _graphQLConfiguration = GraphQLConfiguration();
  QueryMutation _queryMutation = QueryMutation();
  final EditionsDao _editionsDao = EditionsDao();

  Future<List> getPublishedEditions() async {
    GraphQLClient _client = _graphQLConfiguration.clientToQuery();

    QueryResult result = await _client.query(
        QueryOptions(documentNode: gql(_queryMutation.publishedEditions())));

    if (!result.hasException) {
      return result.data['publishedEditions'];
    }
    throw result.exception;
  }

  Future<String> getReference()async{
    print('we here');
    return await _editionsDao.getReference();
  }
}
