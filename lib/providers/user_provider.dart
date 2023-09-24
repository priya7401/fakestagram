import 'package:fakestagram/models/models.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  bool? _isLoading = false;
  String? _token;

  User? get user => _user;
  bool get isLoading => _isLoading ?? false;
  String? get token => _token;

  void setLoader(bool? value) {
    _isLoading = value;
    notifyListeners();
  }

  void setUser(data) {
    _user = data;
    notifyListeners();
  }

  void setToken(String? token) {
    _token = token;
    notifyListeners();
  }
}
