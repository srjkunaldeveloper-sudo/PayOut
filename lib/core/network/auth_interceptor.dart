import 'package:dio/dio.dart';
import 'package:payout/features/auth/services/session_manager.dart';

/// Network Authentication Interceptor.
/// Automatically attaches Bearer token to outgoing API requests
/// and handles 401 Unauthorized token refresh boundaries.
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO(api): Attach Bearer token from secure token storage
    final token = SessionManager.instance.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // TODO(api): Handle 401 Unauthorized by attempting refresh token rotation
    if (err.response?.statusCode == 401) {
      // Future: Trigger token refresh flow or broadcast SessionExpired event
    }
    super.onError(err, handler);
  }
}
