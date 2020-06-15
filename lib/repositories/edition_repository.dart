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

  Future<Map<dynamic, dynamic>> getReference({int editionId}) async {
    return await _editionsDao.getReference(editionId: editionId);
  }

  Future<bool> saveReference({int editionId, String reference}) async {
    // await _editionsDao.deleteReference();
    return await _editionsDao.saveReference(
          editionId: editionId,
          reference: reference,
        ) ==
        1;
  }
}
