import 'package:dio/dio.dart';
import 'package:fakestagram/services/dio_client.dart';
import 'package:fakestagram/models/models.dart';
import 'package:fakestagram/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserService {
  final Dio apiClient = dioClient;

  void followRequestList(BuildContext context) async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);

    userProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse = await apiClient.get(
          "/user_management/user/follow_requests",
          options: getAuthHeaders(context));
      final followRequests =
          UserList.fromJson(dioResponse.data["follow_requests"]);

      userProvider.setFollowRequests(followRequests.users);
      userProvider.setLoader(false);
    } on DioException catch (dioError) {
      userProvider.setLoader(false);
      final Response? errorResponse = dioError.response;
      debugPrint(
          "=========== get follow requests list error block ==============");
      debugPrint(
          "=========== statusCode: ${errorResponse?.statusCode} ==============");
      debugPrint("=========== error: ${errorResponse?.data} ==============");

      if (dioError.type == DioExceptionType.badResponse) {
        ScaffoldMessenger.of(appProvider.globalNavigator!.currentContext!)
            .showSnackBar(
                SnackBar(content: Text(errorResponse?.data.toString() ?? "")));
      } else {
        ScaffoldMessenger.of(appProvider.globalNavigator!.currentContext!)
            .showSnackBar(
                SnackBar(content: Text(errorResponse?.data["message"])));
      }
    } catch (err) {
      userProvider.setLoader(false);
      debugPrint(
          "=========== get follow requests list catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }

  void followSuggestionsList(BuildContext context) async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);

    userProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse = await apiClient.get(
          "/user_management/user/follow_suggestions",
          options: getAuthHeaders(context));
      final followSuggestions = UserList.fromJson(dioResponse.data);

      userProvider.setFollowSuggestions(followSuggestions.users);
      userProvider.setLoader(false);
    } on DioException catch (dioError) {
      userProvider.setLoader(false);
      final Response? errorResponse = dioError.response;
      debugPrint(
          "=========== get follow suggestions list error block ==============");
      debugPrint(
          "=========== statusCode: ${errorResponse?.statusCode} ==============");
      debugPrint("=========== error: ${errorResponse?.data} ==============");

      if (dioError.type == DioExceptionType.badResponse) {
        ScaffoldMessenger.of(appProvider.globalNavigator!.currentContext!)
            .showSnackBar(
                SnackBar(content: Text(errorResponse?.data.toString() ?? "")));
      } else {
        ScaffoldMessenger.of(appProvider.globalNavigator!.currentContext!)
            .showSnackBar(
                SnackBar(content: Text(errorResponse?.data["message"])));
      }
    } catch (err) {
      userProvider.setLoader(false);
      debugPrint(
          "=========== get follow suggestions list catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }

  void acceptRejectRequest(
      Map<String, dynamic> data, BuildContext context) async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);

    userProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse = await apiClient.put(
          "/user_management/user/request",
          data: data,
          options: getAuthHeaders(context));
      final user = User.fromJson(dioResponse.data["user"]);

      userProvider.setUser(user);
      followRequestList(context);
      followSuggestionsList(context);
      userProvider.setLoader(false);
    } on DioException catch (dioError) {
      userProvider.setLoader(false);
      final Response? errorResponse = dioError.response;
      debugPrint(
          "=========== accept reject request error block ==============");
      debugPrint(
          "=========== statusCode: ${errorResponse?.statusCode} ==============");
      debugPrint("=========== error: ${errorResponse?.data} ==============");

      if (dioError.type == DioExceptionType.badResponse) {
        ScaffoldMessenger.of(appProvider.globalNavigator!.currentContext!)
            .showSnackBar(
                SnackBar(content: Text(errorResponse?.data.toString() ?? "")));
      } else {
        ScaffoldMessenger.of(appProvider.globalNavigator!.currentContext!)
            .showSnackBar(
                SnackBar(content: Text(errorResponse?.data["message"])));
      }
    } catch (err) {
      userProvider.setLoader(false);
      debugPrint(
          "=========== accept reject request catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }

  void followersList(BuildContext context) async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);

    userProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse = await apiClient.get(
          "/user_management/user/followers",
          options: getAuthHeaders(context));
      final followers = UserList.fromJson(dioResponse.data["followers"]);

      userProvider.setFollowRequests(followers.users);
      userProvider.setLoader(false);
    } on DioException catch (dioError) {
      userProvider.setLoader(false);
      final Response? errorResponse = dioError.response;
      debugPrint("=========== get followers list error block ==============");
      debugPrint(
          "=========== statusCode: ${errorResponse?.statusCode} ==============");
      debugPrint("=========== error: ${errorResponse?.data} ==============");

      if (dioError.type == DioExceptionType.badResponse) {
        ScaffoldMessenger.of(appProvider.globalNavigator!.currentContext!)
            .showSnackBar(
                SnackBar(content: Text(errorResponse?.data.toString() ?? "")));
      } else {
        ScaffoldMessenger.of(appProvider.globalNavigator!.currentContext!)
            .showSnackBar(
                SnackBar(content: Text(errorResponse?.data["message"])));
      }
    } catch (err) {
      userProvider.setLoader(false);
      debugPrint("=========== get followers list catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }

  void followingList(BuildContext context) async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);

    userProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse = await apiClient.get(
          "/user_management/user/following",
          options: getAuthHeaders(context));
      final following = UserList.fromJson(dioResponse.data["following"]);

      userProvider.setFollowing(following.users);
      userProvider.setLoader(false);
    } on DioException catch (dioError) {
      userProvider.setLoader(false);
      final Response? errorResponse = dioError.response;
      debugPrint("=========== get following list error block ==============");
      debugPrint(
          "=========== statusCode: ${errorResponse?.statusCode} ==============");
      debugPrint("=========== error: ${errorResponse?.data} ==============");

      if (dioError.type == DioExceptionType.badResponse) {
        ScaffoldMessenger.of(appProvider.globalNavigator!.currentContext!)
            .showSnackBar(
                SnackBar(content: Text(errorResponse?.data.toString() ?? "")));
      } else {
        ScaffoldMessenger.of(appProvider.globalNavigator!.currentContext!)
            .showSnackBar(
                SnackBar(content: Text(errorResponse?.data["message"])));
      }
    } catch (err) {
      userProvider.setLoader(false);
      debugPrint("=========== get following list catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }

  void removeFollower(Map<String, dynamic> data, BuildContext context) async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);

    userProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse = await apiClient.put(
          "/user_management/user/remove_follower",
          data: data,
          options: getAuthHeaders(context));
      final user = User.fromJson(dioResponse.data["user"]);

      userProvider.setUser(user);
      followersList(context);
      userProvider.setLoader(false);
    } on DioException catch (dioError) {
      userProvider.setLoader(false);
      final Response? errorResponse = dioError.response;
      debugPrint("=========== remove follower error block ==============");
      debugPrint(
          "=========== statusCode: ${errorResponse?.statusCode} ==============");
      debugPrint("=========== error: ${errorResponse?.data} ==============");

      if (dioError.type == DioExceptionType.badResponse) {
        ScaffoldMessenger.of(appProvider.globalNavigator!.currentContext!)
            .showSnackBar(
                SnackBar(content: Text(errorResponse?.data.toString() ?? "")));
      } else {
        ScaffoldMessenger.of(appProvider.globalNavigator!.currentContext!)
            .showSnackBar(
                SnackBar(content: Text(errorResponse?.data["message"])));
      }
    } catch (err) {
      userProvider.setLoader(false);
      debugPrint("=========== remove follower catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }

  void followUser(Map<String, dynamic> data, BuildContext context) async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);

    userProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse = await apiClient.put(
          "/user_management/user/follow",
          data: data,
          options: getAuthHeaders(context));
      final user = User.fromJson(dioResponse.data["user"]);

      userProvider.setUser(user);
      followSuggestionsList(context);
      userProvider.setLoader(false);
    } on DioException catch (dioError) {
      userProvider.setLoader(false);
      final Response? errorResponse = dioError.response;
      debugPrint("=========== follow user error block ==============");
      debugPrint(
          "=========== statusCode: ${errorResponse?.statusCode} ==============");
      debugPrint("=========== error: ${errorResponse?.data} ==============");

      if (dioError.type == DioExceptionType.badResponse) {
        ScaffoldMessenger.of(appProvider.globalNavigator!.currentContext!)
            .showSnackBar(
                SnackBar(content: Text(errorResponse?.data.toString() ?? "")));
      } else {
        ScaffoldMessenger.of(appProvider.globalNavigator!.currentContext!)
            .showSnackBar(
                SnackBar(content: Text(errorResponse?.data["message"])));
      }
    } catch (err) {
      userProvider.setLoader(false);
      debugPrint("=========== follow user catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }
}
