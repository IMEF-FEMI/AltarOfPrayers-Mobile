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

  String myEditions({int editionId}){
    return """
      query{
        myEditions(editionId: $editionId){
          id
          reference
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
            monthOne
            monthTwo
            monthThree
          }
        }
      }
    """;
  }
}
