import 'package:payout/core/network/network_exception.dart';

/// Centralized Error Message Mapper.
/// Transforms raw backend exceptions and system errors into user-friendly UI messages
/// without exposing stack traces, internal endpoints, or technical jargon.
class ErrorMessageMapper {
  static String map(Object? error, {String fallback = 'Something went wrong. Please try again.'}) {
    if (error == null) return fallback;

    if (error is NetworkException) {
      switch (error.type) {
        case NetworkExceptionType.unauthorized:
          return 'Your session has expired. Please sign in again.';
        case NetworkExceptionType.forbidden:
          return 'You do not have permission to perform this action.';
        case NetworkExceptionType.notFound:
          return 'The requested information was not found.';
        case NetworkExceptionType.validationError:
          return error.message.isNotEmpty ? error.message : 'Please check your inputs and try again.';
        case NetworkExceptionType.timeout:
        case NetworkExceptionType.networkError:
          return 'Unable to connect. Please check your internet connection.';
        case NetworkExceptionType.serverError:
          return 'Our servers are experiencing issues. Please try again shortly.';
        case NetworkExceptionType.unknown:
          return error.message.isNotEmpty ? error.message : fallback;
      }
    }

    if (error is String) {
      if (error.trim().isNotEmpty && !error.contains('Exception:') && !error.contains('StackTrace')) {
        return error.trim();
      }
    }

    if (error is Exception) {
      final str = error.toString();
      if (str.startsWith('Exception: ')) {
        final clean = str.substring(11).trim();
        if (clean.isNotEmpty && !clean.contains('DioException') && !clean.contains('StackTrace')) {
          return clean;
        }
      }
    }

    return fallback;
  }
}
