import 'package:dio/dio.dart';
import 'package:fakestagram/services/dio_client.dart';
import 'package:fakestagram/models/models.dart';
import 'package:fakestagram/providers/app_provider.dart';
import 'package:fakestagram/providers/user_provider.dart';
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
      final Response dioResponse =
          await apiClient.post("/user_management/auth/login", data: data);
      final user = User.fromJson(dioResponse.data["user"]);
      final token = dioResponse.data["token"];

      userProvider.setUser(user);
      userProvider.setToken(token);
      userProvider.setLoader(false);

      Navigator.of(appProvider.globalNavigator!.currentContext!)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } on DioException catch (dioError) {
      userProvider.setLoader(false);
      final Response? errorResponse = dioError.response;
      debugPrint("=========== sign in user error block ==============");
      debugPrint(
          "=========== statusCode: ${errorResponse?.statusCode} ==============");
      debugPrint("=========== error: ${errorResponse?.data} ==============");

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorResponse?.data["message"])));
    } catch (err) {
      userProvider.setLoader(false);
      debugPrint("=========== sign in user catch block ==============");
      debugPrint("=========== $err ==============");
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
      userProvider.setLoader(false);

      Navigator.of(appProvider.globalNavigator!.currentContext!)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } on DioException catch (dioError) {
      userProvider.setLoader(false);
      final Response? errorResponse = dioError.response;
      debugPrint("=========== sign up user error block ==============");
      debugPrint(
          "=========== statusCode: ${errorResponse?.statusCode} ==============");
      debugPrint("=========== error: ${errorResponse?.data} ==============");

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorResponse?.data["message"])));
    } catch (err) {
      userProvider.setLoader(false);
      debugPrint("=========== sign up user catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }
}
