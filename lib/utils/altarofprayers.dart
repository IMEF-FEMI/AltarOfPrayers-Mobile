import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AltarOfPrayers{
  static const String app_name = "Altar Of Prayers";
  static const String app_version = "Version 1.0.0";
  static const int app_version_code = 1;
  static const String app_color = "#ffd7167";
  static Color primaryAppColor = Colors.white;
  static Color secondaryAppColor = Colors.black;
  static const String google_sans_family = "GoogleSans";
 
  //* Images
  static const String banner_light = "assets/images/banner_light.png";
  static const String banner_dark = "assets/images/banner_dark.png";

  //* Texts
  static const String welcomeText = "A Dynamic Daily prayer Guide";
  
  //* Preferences
  static SharedPreferences prefs;
  static const String darkModePref = "darkModePref";

}