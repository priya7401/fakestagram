import 'package:dio/dio.dart';
import 'package:fakestagram/services/dio_client.dart';
import 'package:fakestagram/models/models.dart';
import 'package:fakestagram/providers/providers.dart';
import 'package:fakestagram/utils/app_constants.dart';
import 'package:fakestagram/utils/global_widgets.dart';
import 'package:fakestagram/views/auth/sign_in.dart';
import 'package:fakestagram/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthService {
  final Dio apiClient = dioClient;

  void signIn(Map<String, dynamic> data, BuildContext context) async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);

    userProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse = await apiClient.post(
        "/user_management/auth/login",
        data: data,
      );
      final user = User.fromJson(dioResponse.data["user"]);
      final token = dioResponse.data["token"];

      userProvider.setUser(user);
      userProvider.setToken(token);
      await appProvider.setPrefsUser(dioResponse.data["user"]);
      await appProvider.setPrefsToken(dioResponse.data["token"]);
      userProvider.setLoader(false);

      Navigator.of(appProvider.globalNavigator!.currentContext ?? context)
          .pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on DioException catch (dioError) {
      userProvider.setLoader(false);
      debugPrint("=========== sign in user error block ==============");
      apiSnackbar(
        appProvider.globalNavigator!.currentContext ?? context,
        dioError,
      );
      return;
    } catch (err) {
      userProvider.setLoader(false);
      debugPrint("=========== sign in user catch block ==============");
      debugPrint("=========== $err ==============");
      return;
    }
  }

  void signUp(Map<String, dynamic> data, BuildContext context) async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);

    userProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse =
          await apiClient.post("/user_management/auth/register", data: data);
      final user = User.fromJson(dioResponse.data["user"]);
      final token = dioResponse.data["token"];

      userProvider.setUser(user);
      userProvider.setToken(token);
      appProvider.setPrefsUser(dioResponse.data["user"]);
      appProvider.setPrefsToken(dioResponse.data["token"]);
      userProvider.setLoader(false);

      Navigator.of(appProvider.globalNavigator!.currentContext ?? context)
          .pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on DioException catch (dioError) {
      userProvider.setLoader(false);
      debugPrint("=========== sign up user error block ==============");
      apiSnackbar(
        appProvider.globalNavigator!.currentContext ?? context,
        dioError,
      );
      return;
    } catch (err) {
      userProvider.setLoader(false);
      debugPrint("=========== sign up user catch block ==============");
      debugPrint("=========== $err ==============");
      return;
    }
  }

  void logout(BuildContext context) async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);

    userProvider.setLoader(true);
    try {
      //58977
      await apiClient.post(
        "/user_management/auth/logout",
        options: getAuthHeaders(context),
      );

      userProvider.setUser(null);
      userProvider.setToken(null);
      appProvider.setPrefsUser(null);
      appProvider.setPrefsToken(null);
      userProvider.setLoader(false);
    } on DioException catch (dioError) {
      forceLogout(appProvider.globalNavigator!.currentContext ?? context);
      userProvider.setLoader(false);
      debugPrint("=========== logout user error block ==============");
      return;
    } catch (err) {
      forceLogout(appProvider.globalNavigator!.currentContext ?? context);
      userProvider.setLoader(false);
      debugPrint("=========== logout user catch block ==============");
      debugPrint("=========== $err ==============");
      return;
    }
  }

  void forceLogout(BuildContext context) async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);

    userProvider.setLoader(true);
    try {
      userProvider.setUser(null);
      userProvider.setToken(null);
      appProvider.setPrefsUser(null);
      appProvider.setPrefsToken(null);
      userProvider.setLoader(false);
      if (appProvider.currScreen != AppScreens.singIn.name) {
        Navigator.of(appProvider.globalNavigator!.currentContext ?? context)
            .pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SignIn()),
                (route) => false);
        appProvider.setCurrScreen(AppScreens.singIn.name);
      }
    } catch (err) {
      userProvider.setLoader(false);
      debugPrint("=========== force logout user catch block ==============");
      debugPrint("=========== $err ==============");
      return;
    }
  }
}
