import 'package:flutter/material.dart';

class Tools {
  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static List<Color> multiColors = [
    Colors.red,
    Colors.amber,
    Colors.green,
    Colors.blue,
  ];

  static List<String> monthString = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  static List<String> propheicPrayers = [
    "Today is the day of my advancement",
    "Today is the day of my breakthrough",
    "Today is the day of my celebration",
    "Today is the day of my dominion",
    "Today is the day of my expansion",
    "Today is the day of my favour",
    "Today is the day of my greatness",
    "Today is the day of my honour",
    "Today is the day of my increase",
    "Today is the day of my Jubilee",
    "Today is the day of my laughter",
    "Today is the day of my manifestation",
    "Today is the day of new things in my life",
    "Today is the day of my overflowing blessing",
    "Today my enemies will regret pursueing after me",
    "God will add honey to my life",
    "God will add salt to my life",
    "God will make a difference in my life",
    "Today my helper shall not die",
    "Today my business shall not die",
    "Today shall not be a day of struggle for me",
    "Today shall not be a day of weeping for me",
    "Today shall not be a day of affliction for me",
    "Thank God for answering your prayers",
  ];

  String aboutText =
      "Altar of prayers is a DYNAMIC DAILY PRAYER GUIDE written and Authored by PASTOR J. S. AKANDE The General overseer of Covenant of Restoration Ministry with a mission to help you build a consistent and effective prayer life without struggle, To set the captive free, Restore hope to the hopeless and Set many feet on the pedestal of success ";

  String contactText =
      "You can reach us at:\nConvenant of Restoration Ministries Trikania Kaduna \nKaduna South Nigeria, \nP.O.BOX 6484 \n08033190291 \naltarofprayersteam@gmail.com";

  
}
