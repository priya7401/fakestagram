import 'package:fakestagram/models/models.dart';
import 'package:flutter/foundation.dart';

class PostsProvider extends ChangeNotifier {
  List<Post>? _posts;
  bool? _isLoading = false;

  List<Post>? get posts => _posts;
  bool get isLoading => _isLoading ?? false;

  void setLoader(bool? value) {
    _isLoading = value;
    notifyListeners();
  }

  void setPosts(data) {
    _posts = data;
    notifyListeners();
  }
}
