import 'package:altar_of_prayers/database/editions_dao.dart';
import 'package:altar_of_prayers/graphql/graphql.dart';
import 'package:altar_of_prayers/models/edition.dart';
import 'package:altar_of_prayers/models/user.dart';
import 'package:altar_of_prayers/repositories/user_repository.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EditionsRepository {
  // graphql configurations
  GraphQLConfiguration _graphQLConfiguration = GraphQLConfiguration();

  // all queries/mutation in one place
  QueryMutation _queryMutation = QueryMutation();

  // edition data access object
  final EditionsDao _editionsDao = EditionsDao();

  // user repo
  final UserRepository _userRepository = UserRepository();

  Future<List> getPublishedEditions() async {
    GraphQLClient _client = await _graphQLConfiguration.clientToQuery();

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

  Future<bool> deleteReference({int editionId}) async {
    return await _editionsDao.deleteReference(editionId: editionId) != 0;
  }

  Future<bool> saveReference({int editionId, String reference}) async {
    // await _editionsDao.deleteReference();

    return await _editionsDao.saveReference(
          editionId: editionId,
          reference: reference,
        ) ==
        1;
    // go ahead and complete transact
  }

  Future<Edition> confirmPayment(
      {int editionId, String reference, String paidFor}) async {
    var ref = await getReference(editionId: editionId);
    if (ref == null) {
      await saveReference(
        reference: reference,
        editionId: editionId,
      );
    }

    GraphQLClient _client = await _graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.mutate(MutationOptions(
      documentNode: gql(_queryMutation.confirmPayment(
          editionId: editionId, reference: reference, paidFor: paidFor)),
    ));

    if (!result.hasException) {
      if (result.data['confirmPayment']['error'] != null) {
        print('Success: ${result.data['confirmPayment']['success']}');
        print('error: ${result.data['confirmPayment']['error']}');
        return null;
      }

      Map<String, dynamic> userEdition;
      List<Map<String, dynamic>> giftedEditions = [];
      User _user = await _userRepository.getUser();
      // get the edition the current user should use (one paid on his behalf) regardless of who
      (result.data['confirmPayment']['editionPurchase'] as List)
          .forEach((edition) {
        if (edition['paidFor']['email'] == _user.email) {
          userEdition = edition;
        } else {
          giftedEditions.add(edition);
        }
      });

      Edition edition =
          Edition.fromServerDatabaseJson(userEdition, giftedEditions);
      var dbEdition = await _editionsDao.getEdition(editionId: edition.id);
      if (dbEdition == null) await _editionsDao.saveEdition(edition);
      return edition;
    } else {
      throw result.exception;
    }
  }

  Future<Edition> getEdition({int editionId}) async {
    var editionObj = await _editionsDao.getEdition(editionId: editionId);
    if (editionObj == null) {
      GraphQLClient _client = await _graphQLConfiguration.clientToQuery();
      QueryResult result = await _client.query(QueryOptions(
          documentNode: gql(_queryMutation.myEditions(editionId: editionId))));
      if (!result.hasException) {
        Map<String, dynamic> userEdition;
        List<Map<String, dynamic>> giftedEditions = [];
        User _user = await _userRepository.getUser();
        // get the edition the current user should use (one paid on his behalf) regardless of who
        (result.data['myEditions'] as List).forEach((edition) {
          if (edition['paidFor']['email'] == _user.email) {
            userEdition = edition;
          } else {
            giftedEditions.add(edition);
          }
        });
        Edition edition =
            Edition.fromServerDatabaseJson(userEdition, giftedEditions);
        var dbEdition = await _editionsDao.getEdition(editionId: edition.id);
        if (dbEdition == null) await _editionsDao.saveEdition(edition);
        return edition;
      }
      return null;
    }
    Edition edition = Edition.fromDatabaseJson(editionObj);
    return edition;
  }
}
