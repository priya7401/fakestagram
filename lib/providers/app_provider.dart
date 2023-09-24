import 'package:flutter/cupertino.dart';

class AppProvider extends ChangeNotifier{

  GlobalKey<NavigatorState>? globalNavigator = GlobalKey<NavigatorState>();

  void setNavigator(navigatorKey) {
    globalNavigator = navigatorKey;
    notifyListeners();
  }
}