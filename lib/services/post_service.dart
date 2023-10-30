import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fakestagram/providers/providers.dart';
import 'package:fakestagram/services/dio_client.dart';
import 'package:fakestagram/models/models.dart';
import 'package:fakestagram/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostService {
  final Dio apiClient = dioClient;

  void getPosts(BuildContext context) async {
    final PostsProvider postsProvider =
        Provider.of<PostsProvider>(context, listen: false);

    postsProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse = await apiClient.get("/post_management/posts",
          options: getAuthHeaders(context));
      final posts = PostList.fromJson(dioResponse.data);

      postsProvider.setPosts(posts.posts);
      postsProvider.setLoader(false);
    } on DioException catch (dioError) {
      postsProvider.setLoader(false);
      final Response? errorResponse = dioError.response;
      debugPrint("=========== get posts list error block ==============");
      debugPrint(
          "=========== statusCode: ${errorResponse?.statusCode} ==============");
      debugPrint("=========== error: ${errorResponse?.data} ==============");

      if (dioError.type == DioExceptionType.badResponse) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
            SnackBar(content: Text(errorResponse?.data.toString() ?? "")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorResponse?.data["message"])));
      }
    } catch (err) {
      postsProvider.setLoader(false);
      debugPrint("=========== get posts list catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }

  void getPresingedUrl(
      Map<String, dynamic> data, File file, BuildContext context,
      {String? description}) async {
    final PostsProvider postsProvider =
        Provider.of<PostsProvider>(context, listen: false);

    postsProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse = await apiClient.post(
          "/attachment_management/presigned_url",
          data: data,
          options: getAuthHeaders(context));
      Attachment? attachment = Attachment.fromJson(dioResponse.data);

      //upload to s3
      final dio = Dio();
      if (attachment.s3Key != null && attachment.s3Url != null) {
        await dio.put(attachment.s3Url.toString(),
            data: file.readAsBytesSync(),
            options: Options(headers: {
              'Accept': "*/*",
              'Content-Length': file.lengthSync().toString(),
              'Connection': 'keep-alive',
              'Content-Type': 'image/${data['file_type']}'
            }));
        uploadAttachment(attachment, context, description: description);
      } else {
        throw ("Something went wrong! Please try again");
      }
      postsProvider.setLoader(false);
    } on DioException catch (dioError) {
      postsProvider.setLoader(false);
      final Response? errorResponse = dioError.response;
      debugPrint("=========== get presinged url error block ==============");
      debugPrint(
          "=========== statusCode: ${errorResponse?.statusCode} ==============");
      debugPrint("=========== error: ${errorResponse?.data} ==============");

      if (dioError.type == DioExceptionType.badResponse) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
            SnackBar(content: Text(errorResponse?.data.toString() ?? "")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorResponse?.data["message"])));
      }
    } catch (err) {
      postsProvider.setLoader(false);
      debugPrint("=========== get presinged url catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }

  void uploadAttachment(Attachment? attachment, BuildContext context,
      {String? description}) async {
    final PostsProvider postsProvider =
        Provider.of<PostsProvider>(context, listen: false);
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);

    postsProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse = await apiClient.post(
          "/attachment_management/upload_attachment",
          options: getAuthHeaders(context),
          data: {"s3_key": attachment?.s3Key, "description": description});
      Post? post = Post.fromJson(dioResponse.data);

      if (post != null) {
        var currPostsList = postsProvider.posts;
        currPostsList?.add(post);
        postsProvider.setPosts(currPostsList);
      }
      postsProvider.setLoader(false);

      Navigator.of(appProvider.globalNavigator!.currentContext!)
          .pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage(page: 4)));
    } on DioException catch (dioError) {
      postsProvider.setLoader(false);
      final Response? errorResponse = dioError.response;
      debugPrint("=========== upload attachment error block ==============");
      debugPrint(
          "=========== statusCode: ${errorResponse?.statusCode} ==============");
      debugPrint("=========== error: ${errorResponse?.data} ==============");

      if (dioError.type == DioExceptionType.badResponse) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
            SnackBar(content: Text(errorResponse?.data.toString() ?? "")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorResponse?.data["message"])));
      }
    } catch (err) {
      postsProvider.setLoader(false);
      debugPrint("=========== upload attachment catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }

  void deletePost(
      Map<String, dynamic> queryParams, BuildContext context) async {
    final PostsProvider postsProvider =
        Provider.of<PostsProvider>(context, listen: false);

    postsProvider.setLoader(true);
    try {
      //58977
      await apiClient.delete("/posts",
          queryParameters: queryParams, options: getAuthHeaders(context));

      getPosts(context);
      postsProvider.setLoader(false);
    } on DioException catch (dioError) {
      postsProvider.setLoader(false);
      final Response? errorResponse = dioError.response;
      debugPrint("=========== delete post error block ==============");
      debugPrint(
          "=========== statusCode: ${errorResponse?.statusCode} ==============");
      debugPrint("=========== error: ${errorResponse?.data} ==============");

      if (dioError.type == DioExceptionType.badResponse) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
            SnackBar(content: Text(errorResponse?.data.toString() ?? "")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorResponse?.data["message"])));
      }
    } catch (err) {
      postsProvider.setLoader(false);
      debugPrint("=========== delete post catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }

  void likeDislikePost(
      Map<String, dynamic> queryParams, BuildContext context) async {
    final PostsProvider postsProvider =
        Provider.of<PostsProvider>(context, listen: false);

    postsProvider.setLoader(true);
    try {
      //58977
      await apiClient.put("/post_manamgement/posts/like",
          queryParameters: queryParams, options: getAuthHeaders(context));

      getPosts(context);
      postsProvider.setLoader(false);
    } on DioException catch (dioError) {
      postsProvider.setLoader(false);
      final Response? errorResponse = dioError.response;
      debugPrint("=========== like-dislike post error block ==============");
      debugPrint(
          "=========== statusCode: ${errorResponse?.statusCode} ==============");
      debugPrint("=========== error: ${errorResponse?.data} ==============");

      if (dioError.type == DioExceptionType.badResponse) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
            SnackBar(content: Text(errorResponse?.data.toString() ?? "")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorResponse?.data["message"])));
      }
    } catch (err) {
      postsProvider.setLoader(false);
      debugPrint("=========== like-dislike post catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }
}
