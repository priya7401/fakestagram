import 'package:fakestagram/models/models.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  bool? _isLoading = false;
  String? _token;
  String? _fcmToken;
  List<User>? _followSuggestions;
  List<User>? _followRequests;
  List<User>? _followers;
  List<User>? _following;
  User? _follower;

  User? get user => _user;
  bool get isLoading => _isLoading ?? false;
  String? get token => _token;
  String? get fcmToken => _fcmToken;
  List<User>? get followSuggestions => _followSuggestions ?? [];
  List<User>? get followRequests => _followRequests ?? [];
  List<User>? get followers => _followers ?? [];
  List<User>? get following => _following ?? [];
  User? get follower => _follower;

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

  void setFcmToken(String? token) {
    _fcmToken = token;
    notifyListeners();
  }

  void setFollowSuggestions(data) {
    _followSuggestions = data;
    notifyListeners();
  }

  void setFollowRequests(data) {
    _followRequests = data;
    notifyListeners();
  }

  void setFollowers(data) {
    _followers = data;
    notifyListeners();
  }

  void setFollowing(data) {
    _following = data;
    notifyListeners();
  }

  void setFollower(data) {
    _follower = data;
    notifyListeners();
  }
}
