import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fakestagram/providers/providers.dart';
import 'package:fakestagram/services/dio_client.dart';
import 'package:fakestagram/models/models.dart';
import 'package:fakestagram/views/home/home_page.dart';
import 'package:fakestagram/views/home/profile_tab/profile_tab_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostService {
  final Dio apiClient = dioClient;

  void getPosts(BuildContext context) async {
    final PostsProvider postsProvider =
        Provider.of<PostsProvider>(context, listen: false);
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    postsProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse =
          await apiClient.get("/posts", options: getAuthHeaders(userProvider));
      final posts = PostList.fromJson(dioResponse.data["posts"]);

      postsProvider.setPosts(posts);
      postsProvider.setLoader(false);
    } on DioException catch (dioError) {
      postsProvider.setLoader(false);
      final Response? errorResponse = dioError.response;
      debugPrint("=========== get posts list error block ==============");
      debugPrint(
          "=========== statusCode: ${errorResponse?.statusCode} ==============");
      debugPrint("=========== error: ${errorResponse?.data} ==============");

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorResponse?.data["message"])));
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
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    postsProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse = await apiClient.post(
          "/attachment_management/presigned_url",
          data: data,
          options: getAuthHeaders(userProvider));
      Attachment? attachment = Attachment.fromJson(dioResponse.data);

      //upload to s3
      final dio = Dio();
      if (attachment.s3Key != null && attachment.s3Url != null) {
        final Response S3Response = await dio.put(attachment.s3Url.toString(),
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

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorResponse?.data["message"])));
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
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    postsProvider.setLoader(true);
    try {
      //58977
      final Response dioResponse = await apiClient.put(
          "/attachment_management/upload_attachment",
          options: getAuthHeaders(userProvider),
          data: {
            "s3_key": attachment?.s3Key,
            "user_id": userProvider.user?.id,
            "description": description
          });
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

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorResponse?.data["message"])));
    } catch (err) {
      postsProvider.setLoader(false);
      debugPrint("=========== upload attachment catch block ==============");
      debugPrint("=========== $err ==============");
    }
  }
}
