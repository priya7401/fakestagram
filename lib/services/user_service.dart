import 'package:dio/dio.dart';
import 'package:fakestagram/services/dio_client.dart';
import 'package:fakestagram/models/models.dart';
import 'package:fakestagram/providers/providers.dart';
import 'package:fakestagram/utils/global_widgets.dart';
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
      final followRequests = UserList.fromJson(dioResponse.data);

      userProvider.setFollowRequests(followRequests.followRequests);
      userProvider.setLoader(false);
    } on DioException catch (dioError) {
      userProvider.setLoader(false);
      debugPrint(
          "=========== get follow requests list error block ==============");
      apiSnackbar(
        appProvider.globalNavigator!.currentContext ?? context,
        dioError,
      );
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

      userProvider.setFollowSuggestions(followSuggestions.followSuggestions);
      userProvider.setLoader(false);
    } on DioException catch (dioError) {
      userProvider.setLoader(false);
      debugPrint(
          "=========== get follow suggestions list error block ==============");
      apiSnackbar(
        appProvider.globalNavigator!.currentContext ?? context,
        dioError,
      );
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
      followRequestList(appProvider.globalNavigator!.currentContext ?? context);
      followSuggestionsList(
          appProvider.globalNavigator!.currentContext ?? context);
      followersList(appProvider.globalNavigator!.currentContext ?? context);
      userProvider.setLoader(false);
    } on DioException catch (dioError) {
      userProvider.setLoader(false);
      debugPrint(
          "=========== accept reject request error block ==============");
      apiSnackbar(
        appProvider.globalNavigator!.currentContext ?? context,
        dioError,
      );
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
      final followers = UserList.fromJson(dioResponse.data);

      userProvider.setFollowers(followers.followers);
      userProvider.setLoader(false);
    } on DioException catch (dioError) {
      userProvider.setLoader(false);
      debugPrint("=========== get followers list error block ==============");
      apiSnackbar(
        appProvider.globalNavigator!.currentContext ?? context,
        dioError,
      );
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
      final following = UserList.fromJson(dioResponse.data);

      userProvider.setFollowing(following.following);
      userProvider.setLoader(false);
    } on DioException catch (dioError) {
      userProvider.setLoader(false);
      debugPrint("=========== get following list error block ==============");
      apiSnackbar(
        appProvider.globalNavigator!.currentContext ?? context,
        dioError,
      );
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
      followersList(appProvider.globalNavigator!.currentContext ?? context);
      userProvider.setLoader(false);
    } on DioException catch (dioError) {
      userProvider.setLoader(false);
      debugPrint("=========== remove follower error block ==============");
      apiSnackbar(
        appProvider.globalNavigator!.currentContext ?? context,
        dioError,
      );
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
      followSuggestionsList(
          appProvider.globalNavigator!.currentContext ?? context);
      ScaffoldMessenger.of(
              appProvider.globalNavigator!.currentContext ?? context)
          .showSnackBar(SnackBar(content: Text("Request sent")));
      userProvider.setLoader(false);
    } on DioException catch (dioError) {
      userProvider.setLoader(false);
      debugPrint("=========== follow user error block ==============");
      apiSnackbar(
        appProvider.globalNavigator!.currentContext ?? context,
        dioError,
      );
    } catch (err) {
      userProvider.setLoader(false);
      debugPrint("=========== follow user catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }

  void unfollowUser(Map<String, dynamic> data, BuildContext context) async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);

    userProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse = await apiClient.put(
          "/user_management/user/unfollow",
          data: data,
          options: getAuthHeaders(context));
      final user = User.fromJson(dioResponse.data["user"]);

      userProvider.setUser(user);
      followingList(appProvider.globalNavigator!.currentContext ?? context);
      ScaffoldMessenger.of(
              appProvider.globalNavigator!.currentContext ?? context)
          .showSnackBar(SnackBar(content: Text("Unfollowed user")));
      userProvider.setLoader(false);
    } on DioException catch (dioError) {
      userProvider.setLoader(false);
      debugPrint("=========== follow user error block ==============");
      apiSnackbar(
        appProvider.globalNavigator!.currentContext ?? context,
        dioError,
      );
    } catch (err) {
      userProvider.setLoader(false);
      debugPrint("=========== follow user catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }
}
