import 'dart:convert';

class Edition {
  int id;
  String reference;
  Map<String, dynamic> paidFor;
  Map<String, dynamic> paidBy;
  // DateTime purchaseDate;

  String name;
  int startingMonth;
  int year;
  List monthOne;
  List monthTwo;
  List monthThree;

  List copiesGifted;
  // DateTime createdAt;

  Edition({
    this.id,
    this.reference,
    this.paidFor,
    this.paidBy,
    this.name,
    this.startingMonth,
    this.year,
    this.monthOne,
    this.monthTwo,
    this.monthThree,
    this.copiesGifted,
  });

  Edition.fromServerDatabaseJson(
    Map<String, dynamic> userEdition,
    List<Map<String, dynamic>> giftedEditions,
  ) {
    id = int.parse(userEdition['edition']['id']);
    reference = userEdition['reference'];
    paidFor = userEdition['paidFor'];
    paidBy = userEdition['paidBy'];
    name = userEdition['edition']['name'];
    startingMonth = userEdition['edition']['startingMonth'];
    year = userEdition['edition']['year'];
    monthOne = userEdition['edition']['monthOne'];
    monthTwo = userEdition['edition']['monthTwo'];
    monthThree = userEdition['edition']['monthThree'];
    copiesGifted = giftedEditions;
  }

  Map<String, dynamic> toDatabaseJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    // convert to database usable format
    data['id'] = this.id;
    data['reference'] = this.reference;
    data['paid_for'] = JsonEncoder().convert(this.paidFor);
    data['paid_by'] = JsonEncoder().convert(this.paidBy);
    data['name'] = this.name;
    data['starting_month'] = this.startingMonth;
    data['year'] = this.year;
    data['month_one'] = JsonEncoder().convert(this.monthOne);
    data['month_two'] = JsonEncoder().convert(this.monthTwo);
    data['month_three'] = JsonEncoder().convert(this.monthThree);
    data['copies_gifted'] = JsonEncoder().convert(this.copiesGifted);
    return data;
  }

  Edition.fromDatabaseJson(Map<String, dynamic> json) {
    id = json['id'];
    reference = json['reference'];
    paidFor = JsonDecoder().convert(json['paid_for']);
    paidBy = JsonDecoder().convert(json['paid_by']);
    name = json['name'];
    startingMonth = json['starting_month'];
    year = json['year'];
    monthOne = JsonDecoder().convert(json['month_one']);
    monthTwo = JsonDecoder().convert(json['month_two']);
    monthThree = JsonDecoder().convert(json['month_three']);
    copiesGifted = JsonDecoder().convert(json['copies_gifted']);
  }
}
