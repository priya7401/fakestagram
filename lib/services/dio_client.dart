import 'package:dio/dio.dart';
import 'package:fakestagram/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';

const baseUrl = "http://192.168.0.197:58703/api/v1";
Dio dioClient = Dio(BaseOptions(
  baseUrl: baseUrl,
  followRedirects: false,
))
  ..interceptors.addAll([
    PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90),
    // InterceptorsWrapper(onError: (DioException e, handler) async {
    //   if (e.response != null) {
    //     if (e.response?.statusCode == 401) {
    //       //if it is unauthorized request, stop any further
    //       //API calls and force logout the user
    //       // dioClient.close(force: true);
    //       // dioClient.
    //     } else {}
    //   }
    //   handler.next(e);
    // })
  ]);

dynamic getAuthHeaders(BuildContext context) {
  final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);

  return Options(headers: {
    "Authorization": "Bearer ${userProvider.token}",
  });
}
