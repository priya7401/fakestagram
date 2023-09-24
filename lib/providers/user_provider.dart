import 'package:fakestagram/models/models.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  bool? _isLoading = false;

  User get getUser => _user ?? User();
  bool get isLoading => _isLoading ?? false;

  void setLoader(bool? value) {
    _isLoading = value;
    notifyListeners();
  }

  void setUser(data) {
    _user = data;
    notifyListeners();
  }
}