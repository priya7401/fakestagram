import 'package:dio/dio.dart';

const baseUrl = "http://192.168.0.197:58703/api/v1";
final Dio dioClient = Dio(BaseOptions(baseUrl: baseUrl));

dynamic getAuthHeaders(userProvider) {
  return Options(headers: {
    "Authorization": "Bearer ${userProvider.token}",
  });
}
