import 'package:fakestagram/models/models.dart';
import 'package:flutter/foundation.dart';

class PostsProvider extends ChangeNotifier {
  bool? _isLoading = false;
  List<Post>? _posts;
  List<Post>? _followerPosts;
  List<Post>? _feed;

  bool get isLoading => _isLoading ?? false;
  List<Post>? get posts => _posts;
  List<Post>? get followerPosts => _followerPosts;
  List<Post>? get feed => _feed;

  void setLoader(bool? value) {
    _isLoading = value;
    notifyListeners();
  }

  void setPosts(data) {
    _posts = data;
    notifyListeners();
  }

  void setFollowerPosts(data) {
    _followerPosts = data;
    notifyListeners();
  }

  void setFeed(data) {
    _feed = data;
    notifyListeners();
  }
}
