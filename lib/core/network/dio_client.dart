import 'package:dio/dio.dart';
import 'package:payout/core/network/auth_interceptor.dart';
import 'package:payout/core/network/logging_interceptor.dart';

class DioClient {
  static Dio? _dio;

  static Dio get instance {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );
      _dio!.interceptors.add(AuthInterceptor());
      _dio!.interceptors.add(LoggingInterceptor());
    }
    return _dio!;
  }
}
