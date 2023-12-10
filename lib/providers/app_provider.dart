import 'dart:convert';

import 'package:fakestagram/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  GlobalKey<NavigatorState>? globalNavigator = GlobalKey<NavigatorState>();
  bool? _isLoading = false;
  int _prevTabPage = 0;
  String? _currScreen;
  User? _user;
  String? _token;

  bool get isLoading => _isLoading ?? false;
  int get prevTabPage => _prevTabPage;
  String? get currScreen => _currScreen;
  User? get user => _user;
  String? get token => _token;

  void setLoader(bool? value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void setPrevTabPage(page) {
    _prevTabPage = page;
    notifyListeners();
  }

  void setCurrScreen(String screen) {
    _currScreen = screen;
    notifyListeners();
  }

  setPrefsUser(data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (data == null) {
      await prefs.setString('user', '');
    } else {
      final String userString = stringifyUser(data);
      await prefs.setString('user', userString);
    }
    _user = User.fromJson(data ?? {});
    notifyListeners();
  }

  setPrefsToken(String? token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (token == null) {
      await prefs.setString('token', '');
    } else {
      await prefs.setString('token', token);
    }
    _token = token;
    notifyListeners();
  }

  static String stringifyUser(data) {
    try {
      final String userString = jsonEncode(data);
      return userString;
    } catch (err) {
      return '';
    }
  }

  static decodeUser(data) {
    try {
      final userString = jsonDecode(data);
      return userString;
    } catch (err) {
      return User();
    }
  }
}
