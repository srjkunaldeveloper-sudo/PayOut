import 'package:dio/dio.dart';
import 'package:payout/core/network/dio_client.dart';

class ApiClient {
  final Dio _dio = DioClient.instance;

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }
}
