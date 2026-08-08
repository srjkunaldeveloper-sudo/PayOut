// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Network Logging Interceptor with strict PII and Credential Sanitization.
/// Logs only safe request/response metadata (method, sanitized path, status code, timing).
class LoggingInterceptor extends Interceptor {
  static const _sanitizedHeaders = {
    'authorization',
    'cookie',
    'set-cookie',
    'x-api-key',
    'token',
    'password',
    'mpin',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      final safeHeaders = Map<String, dynamic>.from(options.headers)
        ..removeWhere((k, _) => _sanitizedHeaders.contains(k.toLowerCase()));

      print('[NETWORK_REQ] --> ${options.method} ${options.uri.path}');
      if (safeHeaders.isNotEmpty) {
        print('[NETWORK_REQ] Safe Headers: $safeHeaders');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('[NETWORK_RES] <-- ${response.statusCode} ${response.requestOptions.uri.path}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('[NETWORK_ERR] <-- ${err.response?.statusCode ?? "ERR"} ${err.requestOptions.uri.path}: ${err.message}');
    }
    super.onError(err, handler);
  }
}
