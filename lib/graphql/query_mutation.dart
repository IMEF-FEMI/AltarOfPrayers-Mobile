class QueryMutation {
  String register(
      {String fullName, String email, String password, String accountType}) {
    return """
            mutation {
              createUser(
                fullname: "$fullName", email: "$email", password: "$password", admin: false, staff: false, accountType: "$accountType") {
                    error
                    success
                    token
                    user {
                      id
                      email
                      admin
                      staff
                      email
                      fullname
                      accountType
                      isVerified
                  }
              }
            }
          """;
  }

  String resetPassword({String email}) {
    return """
    mutation {
        resetPassword(email: "$email") {
          success
          error
        }
      }
  """;
  }

  String confirmReset({String email, String token, String newPassword}) {
    return """
    mutation {
        confirmReset(email: "$email", code: "$token", newPassword: "$newPassword") {
          success
          error
        }
      }
  """;
  }

  String loginUser({String email, String password, String loginMethod}) {
    return """
      mutation loginUser {
          loginUser(email: "$email", password: "$password", loginMethod: "$loginMethod") {
            token
            success
            error
            user {
              id
              email
              fullname
              accountType
              staff
              admin
              isVerified
    }
  }
}
    """;
  }

  String currentUser() {
    return """query{
          currentUser{
              id
              email
              admin
              staff
              email
              fullname
              accountType
            }
        }
      """;
  }

  String verifyToken({String token}) {
    return """
          mutation{
              verifyToken(token: "$token"){
                  token
              }
            }
    """;
  }

  String sendInvitation({String email}) {
    return """
      mutation sendInvitation{
        sendInvitation(email: "$email"){
          success
        }
      }
    """;
  }

  String getUser({String email}) {
    return """
      query {
        user(email: "$email"){
          id
          fullname
          email
          isVerified
          paidBy{
            id
            paidBy{
              fullname
              email
            }
            paidFor{
              fullname
              email
            }
            edition{
              id
              name
              startingMonth
              year
              published
              createdAt
              monthOne
              monthTwo
              monthThree
            }
          }
          paidFor{
            id
            paidBy{
              fullname
              email
            }
            paidFor{
              fullname
              email
            }
            edition{
              id
              name
              startingMonth
              year
              published
              createdAt
              monthOne
              monthTwo
              monthThree
            }
          }
        }
      }
    """;
  }

  String confirmPayment({int editionId, String reference, String paidFor}) {
    return """
      mutation{
        confirmPayment(editionId: $editionId, reference: "$reference", paidFor: "$paidFor"){
          success
          error
          editionPurchase{
          id
          reference
          paidBy{
            fullname
            email
            createdAt
          }
          paidFor{
            fullname
            email
            createdAt
          }
          edition{
            id
            name
            startingMonth
            year
            published
            monthOne
            monthTwo
            monthThree
          }
      }
    }
  }    
    """;
  }

  String publishedEditions() {
    return """
    query{
      publishedEditions
    }
  """;
  }

  String myEditions({int editionId, int startingMonth, int year}) {
    String query = '';
    if (editionId != null)
      query = 'editionId: $editionId';
    else
      query = 'startingMonth: $startingMonth, year: $year';

    return """
      query{
        myEditions($query){
          id
          reference
          paidBy{
            fullname
            email
            createdAt
          }
          paidFor{
            fullname
            email
            createdAt
          }
          edition{
            id
            name
            startingMonth
            year
            published
            monthOne
            monthTwo
            monthThree
          }
        }
      }
    """;
  }
}
