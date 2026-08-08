import 'package:dio/dio.dart';
import 'package:payout/core/config/app_config.dart';
import 'package:payout/core/network/auth_interceptor.dart';
import 'package:payout/core/network/logging_interceptor.dart';

class DioClient {
  static Dio? _dio;

  static Dio get instance {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.apiBaseUrl,
          connectTimeout: AppConfig.connectTimeout,
          receiveTimeout: AppConfig.receiveTimeout,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      _dio!.interceptors.add(AuthInterceptor());
      _dio!.interceptors.add(LoggingInterceptor());
    }
    return _dio!;
  }

  static void reset() {
    _dio = null;
  }
}
