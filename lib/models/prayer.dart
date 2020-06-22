class Prayer {
  int year;
  int month;
  int day;
  int startingMonth;
  Map prayerPoint;

  Prayer({
    this.year,
    this.month,
    this.day,
    this.startingMonth,
    this.prayerPoint,
  });

  Map<String, dynamic> toDatabaseJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this.year;
    data['month'] = this.month;
    data['day'] = this.day;
    data['starting_month'] = this.startingMonth;
    return data;
  }
}
