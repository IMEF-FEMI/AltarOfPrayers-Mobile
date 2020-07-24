import 'package:altar_of_prayers/database/database.dart';
import 'package:altar_of_prayers/database/editions_dao.dart';
import 'package:altar_of_prayers/database/notifications_dao.dart';
import 'package:altar_of_prayers/database/prayer_dao.dart';
import 'package:altar_of_prayers/graphql/graphql.dart';
import 'package:altar_of_prayers/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation queryMutation = QueryMutation();

  final userDao = UserDao();
  final editionsDao = EditionsDao();
  final notificationsDao = NotificationsDao();
  final prayerDao = PrayerDao();

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  Future<bool> signInWithGoogle() async {
    await signOut();
    try {
      final FirebaseUser firebaseUser = await getFirebaseUser();
      
        String email = firebaseUser.email;
        String password = "123456";

        GraphQLClient _client = await graphQLConfiguration.clientToQuery();

        QueryResult result = await _client.mutate(
          MutationOptions(
              documentNode: gql(queryMutation.loginUser(
                  email: email.toLowerCase(),
                  password: password,
                  loginMethod: "google"))),
        );
        if (!result.hasException) {
          // print("result.data: ${jsonEncode(result.data)}");
          if (result.data['loginUser']['success']) {
            print('''
         id: ${result.data['loginUser']['user']['id']},
         email: ${result.data['loginUser']['user']['email']},
         fullName: ${result.data['loginUser']['user']['fullname']},
         accountType: ${result.data['loginUser']['user']['accountType']},
         staff: ${result.data['loginUser']['user']['staff']},
         admin: ${result.data['loginUser']['user']['admin']},
         isVerified: ${result.data['loginUser']['user']['isVerified']},
         token: ${result.data['loginUser']['token']},
      ''');

            // add user to db
            // get token and add to db
            // return User obj
            final user = new User(
                id: result.data['loginUser']['user']['id'],
                email: result.data['loginUser']['user']['email'],
                fullName: result.data['loginUser']['user']['fullname'],
                accountType: result.data['loginUser']['user']['accountType'],
                token: result.data['loginUser']['token'],
                staff: result.data['loginUser']['user']['staff'],
                admin: result.data['loginUser']['user']['admin'],
                isVerified: result.data['loginUser']['user']['isVerified'],
                createdAt: result.data['loginUser']['user']['createdAt']);

            await userDao.saveUser(user);
            print("user saved");
            return true;
          } else {
            throw result.data['loginUser']['error'];
          }
        } else {
          print('error ${result.exception}');
          if (result.exception.clientException.message
                  .contains("Connection failed") ||
              result.exception.clientException.message.contains("Firebase"))
            throw "Connection Failed! try again";
         
          throw "Authentication Error Try Again!";
        }
      
      
    } catch (e) {
      print('error $e');
      throw e.toString();
    }
  }

  Future<bool> isSignedIn() async {
    return await userDao.getUser() != null;
  }

  Future<bool> signUp(
      {String name, String email, String password, String accountType}) async {
    await signOut();

    GraphQLClient _client = await graphQLConfiguration.clientToQuery();
    // print("name: $name, email: $email, password: $password, accountType: $accountType,");
    // register user
    QueryResult result = await _client.mutate(
      MutationOptions(
          documentNode: gql(queryMutation.register(
        email: email.toLowerCase(),
        password: password,
        fullName: name,
        accountType: accountType,
      ))),
    );

    if (!result.hasException) {
      // print("result.data: ${jsonEncode(result.data)}");
      if (result.data['createUser']['success']) {
        print('''
         id: ${result.data['createUser']['user']['id']},
         email: ${result.data['createUser']['user']['email']},
         fullName: ${result.data['createUser']['user']['fullname']},
         accountType: ${result.data['createUser']['user']['accountType']},
         staff: ${result.data['createUser']['user']['staff']},
         admin: ${result.data['createUser']['user']['admin']},
         isVerified: ${result.data['createUser']['user']['isVerified']},
         token: ${result.data['createUser']['token']},
      ''');

        // add user to db
        // get token and add to db
        // return User obj
        final user = new User(
            id: result.data['createUser']['user']['id'],
            email: result.data['createUser']['user']['email'],
            fullName: result.data['createUser']['user']['fullname'],
            accountType: result.data['createUser']['user']['accountType'],
            token: result.data['createUser']['token'],
            staff: result.data['createUser']['user']['staff'],
            admin: result.data['createUser']['user']['admin'],
            isVerified: result.data['createUser']['user']['isVerified'],
            createdAt: result.data['createUser']['user']['createdAt']);

        await userDao.saveUser(user);
        return true;
      }
      throw result.data['createUser']['error'];
    } else {
      print('error ${result.exception}');
      if (result.exception.clientException.message
          .contains("Connection failed")) throw "Connection Failed! try again";

      throw "Authentication Error! Try Again";
    }
  }

  Future<bool> login({String email, String password}) async {
    await signOut();

    GraphQLClient _client = await graphQLConfiguration.clientToQuery();

    // add user to db
    // get token and add to db
    // return User obj

    QueryResult result = await _client.mutate(
      MutationOptions(
          documentNode: gql(queryMutation.loginUser(
              email: email, password: password, loginMethod: "classic"))),
    );

    if (!result.hasException) {
      // print("result.data: ${jsonEncode(result.data)}");
      if (result.data['loginUser']['success']) {
        print('''
         id: ${result.data['loginUser']['user']['id']},
         email: ${result.data['loginUser']['user']['email']},
         fullName: ${result.data['loginUser']['user']['fullname']},
         accountType: ${result.data['loginUser']['user']['accountType']},
         staff: ${result.data['loginUser']['user']['staff']},
         admin: ${result.data['loginUser']['user']['admin']},
         isVerified: ${result.data['loginUser']['user']['isVerified']},
         token: ${result.data['loginUser']['token']},
      ''');

        // add user to db
        // get token and add to db
        // return User obj
        final user = new User(
            id: result.data['loginUser']['user']['id'],
            email: result.data['loginUser']['user']['email'],
            fullName: result.data['loginUser']['user']['fullname'],
            accountType: result.data['loginUser']['user']['accountType'],
            token: result.data['loginUser']['token'],
            staff: result.data['loginUser']['user']['staff'],
            admin: result.data['loginUser']['user']['admin'],
            isVerified: result.data['loginUser']['user']['isVerified'],
            createdAt: result.data['loginUser']['user']['createdAt']);

        await userDao.saveUser(user);
        print("user saved");
        return true;
      }
      throw result.data['loginUser']['error'];
    } else {
      print('error ${result.exception}');
      if (result.exception.clientException.message
          .contains("Connection failed")) throw "Connection Failed! try again";

      throw "Authentication Error! Try Again";
    }
  }

  Future<bool> signUpWithGoogle() async {
    await signOut();
    try {
      final FirebaseUser firebaseUser = await getFirebaseUser();
      String name = firebaseUser.displayName;
      String email = firebaseUser.email;
      String password = "123456";
      String accountType = "google";

      GraphQLClient _client = await graphQLConfiguration.clientToQuery();

      QueryResult result = await _client.mutate(
        MutationOptions(
            documentNode: gql(queryMutation.register(
          fullName: name,
          email: email.toLowerCase(),
          password: password,
          accountType: accountType,
        ))),
      );
      if (!result.hasException) {
        // print("result.data: ${jsonEncode(result.data)}");

        if (result.data['createUser']['success']) {
          print('''
         id: ${result.data['createUser']['user']['id']},
         email: ${result.data['createUser']['user']['email']},
         fullName: ${result.data['createUser']['user']['fullname']},
         accountType: ${result.data['createUser']['user']['accountType']},
         staff: ${result.data['createUser']['user']['staff']},
         admin: ${result.data['createUser']['user']['admin']},
         isVerified: ${result.data['createUser']['user']['isVerified']},
         token: ${result.data['createUser']['token']},
      ''');

          // add user to db
          // get token and add to db
          // return User obj
          final user = new User(
              id: result.data['createUser']['user']['id'],
              email: result.data['createUser']['user']['email'],
              fullName: result.data['createUser']['user']['fullname'],
              accountType: result.data['createUser']['user']['accountType'],
              token: result.data['createUser']['token'],
              staff: result.data['createUser']['user']['staff'],
              admin: result.data['createUser']['user']['admin'],
              isVerified: result.data['createUser']['user']['isVerified'],
              createdAt: result.data['createUser']['user']['createdAt']);
          await userDao.saveUser(user);
          print("user saved");
          return true;
        }
        throw result.data['createUser']['error'];
      } else {
        print('error ${result.exception}');
        if (result.exception.clientException.message
            .contains("Connection failed"))
          throw "Connection Failed! try again";

        throw "Sign Up Error! Try Again";
      }
    } catch (e) {
      print("error: $e");
      throw e.toString();
    }
  }

  Future<User> getUser() async {
    return userDao.getUser();
  }

  Future fetchUser({String email}) async {
    GraphQLClient _client = await graphQLConfiguration.clientToQuery();

    QueryResult result = await _client.query(
      QueryOptions(
          documentNode: gql(queryMutation.getUser(
        email: email.toLowerCase(),
      ))),
    );

    if (!result.hasException) {
      return result.data;
    } else {
      throw result.exception;
    }
  }

  Future resendConfirmationEmail({String email}) async {
    GraphQLClient _client = await graphQLConfiguration.clientToQuery();

    QueryResult result = await _client.mutate(
      MutationOptions(
          documentNode: gql(queryMutation.resendConfirmationEmail(
        email: email.toLowerCase(),
      ))),
    );

    if (!result.hasException) {
      return result.data;
    } else {
      // print(result.exception);
      throw result.exception;
    }
  }

  Future inviteUser({String email}) async {
    GraphQLClient _client = await graphQLConfiguration.clientToQuery();

    QueryResult result = await _client.mutate(
      MutationOptions(
          documentNode: gql(queryMutation.sendInvitation(
        email: email.toLowerCase(),
      ))),
    );

    if (!result.hasException) {
      return result.data;
    } else {
      throw result.exception;
    }
  }

  Future<Map<String, dynamic>> currentUserInfo() async {
    GraphQLClient _client = await graphQLConfiguration.clientToQuery();

    QueryResult result = await _client.query(
      QueryOptions(documentNode: gql(queryMutation.currentUser())),
    );

    if (!result.hasException) {
      return result.data;
    } else {
      throw result.exception;
    }
  }

  Future<void> signOut() async {
    if (_firebaseAuth.currentUser() != null) {
      Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    }

    // clear all 7 user table except dark mode table
    try {
      await editionsDao.clearReferenceTable();
      await editionsDao.clearEditionsTable();
      await editionsDao.clearSeenEditionsTable();
      await editionsDao.clearSavedPrayersTable();
      await notificationsDao.deleteAllNotifications();
      await userDao.deleteUser();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> resetPassword(String email) async {
    GraphQLClient _client = await graphQLConfiguration.clientToQuery();

    QueryResult result = await _client.mutate(
      MutationOptions(
          documentNode: gql(queryMutation.resetPassword(
        email: email.toLowerCase(),
      ))),
    );
    if (!result.hasException) {
      if (result.data['resetPassword']['success']) {
        return true;
      }
      throw result.data['resetPassword']['error'];
    } else {
      print('goddam error ${result.exception}');
      if (result.exception.clientException.message
          .contains("Connection failed")) throw "Connection Failed! try again";

      throw "Action Failed! Try Again";
    }
  }

  Future<bool> confirmReset(
      String email, String token, String newPassword) async {
    GraphQLClient _client = await graphQLConfiguration.clientToQuery();

    QueryResult result = await _client.mutate(MutationOptions(
        documentNode: gql(queryMutation.confirmReset(
            email: email.toLowerCase(),
            token: token,
            newPassword: newPassword))));

    if (!result.hasException) {
      if (result.data['confirmReset']['success']) {
        return true;
      }
      throw result.data['confirmReset']['error'];
    } else {
      print(result.exception.clientException.message);
      if (result.exception.clientException.message
          .contains("Connection failed")) throw "Connection Failed! try again";

      throw "Action Failed! Try Again";
    }
  }

  Future<FirebaseUser> getFirebaseUser() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final AuthResult authResult =
          await _firebaseAuth.signInWithCredential(credential);
      final FirebaseUser firebaseUser = authResult.user;
      return firebaseUser;
    } catch (e) {
      throw "Try again";
    }
  }
}
