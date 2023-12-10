import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fakestagram/providers/providers.dart';
import 'package:fakestagram/services/dio_client.dart';
import 'package:fakestagram/models/models.dart';
import 'package:fakestagram/utils/global_widgets.dart';
import 'package:fakestagram/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostService {
  final Dio apiClient = dioClient;

  void getPosts(BuildContext context, {String? followerId}) async {
    final PostsProvider postsProvider = Provider.of<PostsProvider>(context, listen: false);
    final AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    postsProvider.setLoader(true);
    try {
      postsProvider.setFollowerPosts(null);
      //58977
      final Response dioResponse = await apiClient.get(
        "/post_management/posts",
        options: getAuthHeaders(context),
        queryParameters: {"follower_id": followerId},
      );

      final posts = PostList.fromJson(dioResponse.data);
      //if followerId is not null, get call made to fetch follower/following posts,
      //so store data accordingly
      if (followerId == null) {
        postsProvider.setPosts(posts.posts);
      } else {
        postsProvider.setFollowerPosts(posts.posts);
      }

      postsProvider.setLoader(false);
    } on DioException catch (dioError) {
      postsProvider.setLoader(false);
      debugPrint("=========== get posts list error block ==============");
      apiSnackbar(
        appProvider.globalNavigator!.currentContext ?? context,
        dioError,
      );
    } catch (err) {
      postsProvider.setLoader(false);
      debugPrint("=========== get posts list catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }

  void getPresingedUrl(Map<String, dynamic> data, File file, BuildContext context,
      {Function(String s3Key)? callback}) async {
    final PostsProvider postsProvider = Provider.of<PostsProvider>(context, listen: false);
    final AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    postsProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse =
          await apiClient.post("/attachment_management/presigned_url", data: data, options: getAuthHeaders(context));
      Attachment? attachment = Attachment.fromJson(dioResponse.data);

      //upload to s3
      final dio = Dio();
      if (attachment.s3Key != null && attachment.s3Url != null) {
        await dio.put(
          attachment.s3Url.toString(),
          data: file.readAsBytesSync(),
          options: Options(
            headers: {
              'Accept': "*/*",
              'Content-Length': file.lengthSync().toString(),
              'Connection': 'keep-alive',
              'Content-Type': 'image/${data['file_type']}'
            },
          ),
        );
        if (callback != null) {
          callback(attachment.s3Key ?? "");
        }
      } else {
        throw ("Something went wrong! Please try again");
      }
      postsProvider.setLoader(false);
    } on DioException catch (dioError) {
      postsProvider.setLoader(false);
      debugPrint("=========== get presinged url error block ==============");
      apiSnackbar(
        appProvider.globalNavigator!.currentContext ?? context,
        dioError,
      );
    } catch (err) {
      postsProvider.setLoader(false);
      debugPrint("=========== get presinged url catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }

  void uploadPost(Map<String, dynamic> data, BuildContext context) async {
    final PostsProvider postsProvider = Provider.of<PostsProvider>(context, listen: false);
    final AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    postsProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse = await apiClient.post("/attachment_management/upload_attachment",
          options: getAuthHeaders(context), data: data);
      Post? post = Post.fromJson(dioResponse.data);

      if (post != null) {
        var currPostsList = postsProvider.posts;
        currPostsList?.add(post);
        postsProvider.setPosts(currPostsList);
      }
      postsProvider.setLoader(false);

      Navigator.of(appProvider.globalNavigator!.currentContext!)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage(page: 4)));
    } on DioException catch (dioError) {
      postsProvider.setLoader(false);
      debugPrint("=========== upload post error block ==============");
      apiSnackbar(
        appProvider.globalNavigator!.currentContext ?? context,
        dioError,
      );
    } catch (err) {
      postsProvider.setLoader(false);
      debugPrint("=========== upload post catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }

  void deletePost(Map<String, dynamic> queryParams, BuildContext context) async {
    final PostsProvider postsProvider = Provider.of<PostsProvider>(context, listen: false);
    final AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    postsProvider.setLoader(true);
    try {
      //58977
      await apiClient.delete("/post_management/posts", queryParameters: queryParams, options: getAuthHeaders(context));

      getPosts(appProvider.globalNavigator!.currentContext ?? context);
      postsProvider.setLoader(false);
    } on DioException catch (dioError) {
      postsProvider.setLoader(false);
      debugPrint("=========== delete post error block ==============");
      apiSnackbar(
        appProvider.globalNavigator!.currentContext ?? context,
        dioError,
      );
    } catch (err) {
      postsProvider.setLoader(false);
      debugPrint("=========== delete post catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }

  void likeDislikePost(Map<String, dynamic> queryParams, BuildContext context, {String? user}) async {
    final PostsProvider postsProvider = Provider.of<PostsProvider>(context, listen: false);
    final AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    postsProvider.setLoader(true);
    try {
      //58977
      await apiClient.put(
        "/post_management/posts/like",
        queryParameters: queryParams,
        options: getAuthHeaders(context),
      );

      if (user != null) {
        switch (user) {
          case "feed":
            getFeed(appProvider.globalNavigator!.currentContext ?? context);
            break;
          case "user":
            getPosts(appProvider.globalNavigator!.currentContext ?? context);
            break;
          case "follower":
            getPosts(
              appProvider.globalNavigator!.currentContext ?? context,
              followerId: userProvider.follower?.id,
            );
            break;
        }
      } else {
        getPosts(appProvider.globalNavigator!.currentContext ?? context);
      }
      postsProvider.setLoader(false);
    } on DioException catch (dioError) {
      postsProvider.setLoader(false);
      debugPrint("=========== like-dislike post error block ==============");
      apiSnackbar(
        appProvider.globalNavigator!.currentContext ?? context,
        dioError,
      );
    } catch (err) {
      postsProvider.setLoader(false);
      debugPrint("=========== like-dislike post catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }

  void getFeed(BuildContext context) async {
    final PostsProvider postsProvider = Provider.of<PostsProvider>(context, listen: false);
    final AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    postsProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse = await apiClient.get(
        "/post_management/feed",
        options: getAuthHeaders(context),
      );
      final posts = PostList.fromJson(dioResponse.data);
      final feed = postsProvider.feed ?? [];
      feed.addAll(posts.posts ?? []);
      postsProvider.setFeed(feed);

      postsProvider.setLoader(false);
    } on DioException catch (dioError) {
      postsProvider.setLoader(false);
      debugPrint("=========== get feed list error block ==============");
      apiSnackbar(
        appProvider.globalNavigator!.currentContext ?? context,
        dioError,
      );
    } catch (err) {
      postsProvider.setLoader(false);
      debugPrint("=========== get feed list catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }

  void getPostDetails(BuildContext context, String? postId) async {
    final PostsProvider postsProvider = Provider.of<PostsProvider>(context, listen: false);
    final AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    // using it only to get post details when a new post alert is received via fcm
    postsProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse = await apiClient.get(
        "/post_management/post",
        options: getAuthHeaders(context),
        queryParameters: {"post_id": postId},
      );
      final Post post = Post.fromJson(dioResponse.data["post"]);
      final feed = postsProvider.feed ?? [];
      feed.insert(0, post);
      postsProvider.setFeed(feed);

      postsProvider.setLoader(false);
    } on DioException catch (dioError) {
      postsProvider.setLoader(false);
      debugPrint("=========== get feed list error block ==============");
      apiSnackbar(
        appProvider.globalNavigator!.currentContext ?? context,
        dioError,
      );
    } catch (err) {
      postsProvider.setLoader(false);
      debugPrint("=========== get feed list catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }
}
