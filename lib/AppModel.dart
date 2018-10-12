import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel extends Model {
  AppModel(String lang, SharedPreferences es) {
     _appLocale = Locale(lang);
     sharedPreferences = es;
  }

  Locale _appLocale;
  Locale get appLocal => _appLocale ?? Locale("ar");
  SharedPreferences sharedPreferences;

  static Future<AppModel> initial() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String lang = (sharedPreferences.getString('lang') ?? 'en');

    return AppModel(
      lang,
      sharedPreferences
    );
  }

  void changeDirection() async {
    if (_appLocale == Locale("ar")) {
      await setDirection('en');
    } else {
      await setDirection('ar');
    }
  }

  void setDirection(String lang) async {
    _appLocale = Locale(lang);
    await sharedPreferences.setString('lang', lang);
    notifyListeners();
  }
}