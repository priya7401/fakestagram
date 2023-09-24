import 'package:flutter/cupertino.dart';

class AppProvider extends ChangeNotifier {
  GlobalKey<NavigatorState>? globalNavigator = GlobalKey<NavigatorState>();
  int _prevTabPage = 0;

  int get prevTabPage => _prevTabPage;

  void setPrevTabPage(page) {
    _prevTabPage = page;
    notifyListeners();
  }
}
