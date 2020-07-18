
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
      List publishedEditions = result.data['publishedEditions'];

      return publishedEditions;
    }
    throw result.exception;
  }

  Future<Map> getSeenEditions() async {
    return await _editionsDao.getSeenEditions();
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
  }

  Future<bool> saveSeenEdition({int editionId}) async {
    return await _editionsDao.saveSeenEdition(
          editionId: editionId,
        ) ==
        1;
  }

  Future<Edition> confirmPayment(
      {int editionId, String reference, String paidFor}) async {
   
    var ref = await getReference(editionId: editionId);
    if (ref == null) {
      await saveReference(
        reference: reference,
        editionId: editionId,
      );
      await saveSeenEdition(
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
      await _editionsDao.saveEdition(edition);
      return edition;
    } else {
      throw result.exception;
    }
  }

  Future<List<Edition>> getLocalEditions() async {
    List<Map<String, dynamic>> localEditions = await _editionsDao.getEditions();
    if (localEditions == null) return [];
    List<Edition> editions = localEditions.length != 0
        ? localEditions
            .map((edition) => Edition.fromDatabaseJson(edition))
            .toList()
        : [];
    return editions;
  }

  Future<Edition> getEdition(
      {int editionId, int startingMonth, int year}) async {
    var editionObj;
    if (editionId != null) {
      editionObj = await _editionsDao.getEdition(editionId: editionId);
    } else {
      editionObj = await _editionsDao.getEdition(
          startingMonth: startingMonth, year: year);
    }
    if (editionObj == null) {
      GraphQLClient _client = await _graphQLConfiguration.clientToQuery();
      QueryResult result = await _client.query(
        QueryOptions(
          documentNode: gql(
            _queryMutation.myEditions(
                editionId: editionId, startingMonth: startingMonth, year: year),
          ),
        ),
      );
      if (!result.hasException) {
        Map<String, dynamic> userEdition = {};
        List<Map<String, dynamic>> giftedEditions = [];
        User _user = await _userRepository.getUser();

        if ((result.data['myEditions'] as List).length == 0) return null;
        // get the edition the current user should use (one paid on his behalf) regardless of who
        (result.data['myEditions'] as List).forEach((edition) {
          if (edition['paidFor']['email'] == _user.email) {
            userEdition = edition;
          } else {
            giftedEditions.add(edition);
          }
        });

        // if returned editions map is not empty

        Edition edition =
            Edition.fromServerDatabaseJson(userEdition, giftedEditions);
        await _editionsDao.saveEdition(edition);
        return edition;
      } else {
        print(result.exception);
        throw result.exception;
      }
    }

    Edition edition = Edition.fromDatabaseJson(editionObj);
    return edition;
  }
}
