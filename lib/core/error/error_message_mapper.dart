import 'package:firebase_auth/firebase_auth.dart';
import 'package:payout/core/network/network_exception.dart';

/// Centralized Error Message Mapper.
/// Transforms raw backend exceptions and system errors into user-friendly UI messages
/// without exposing stack traces, internal endpoints, or technical jargon.
class ErrorMessageMapper {
  static String map(Object? error, {String fallback = 'Something went wrong. Please try again.'}) {
    if (error == null) return fallback;

    if (error is FirebaseAuthException) {
      return mapFirebaseAuthCode(error.code, message: error.message, fallback: fallback);
    }

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

  /// Maps Firebase Authentication error codes to user-friendly messages.
  static String mapFirebaseAuthCode(String code, {String? message, String fallback = 'Authentication failed. Please try again.'}) {
    switch (code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact customer support.';
      case 'user-not-found':
        return 'No account found with this email. Please check or create an account.';
      case 'wrong-password':
        return 'Incorrect password entered. Please try again.';
      case 'invalid-credential':
        return 'Invalid email or password. Please verify your credentials.';
      case 'email-already-in-use':
        return 'An account already exists with this email. Please log in.';
      case 'operation-not-allowed':
        return 'Sign-in method is not enabled. Please contact support.';
      case 'weak-password':
        return 'The password is too weak. Please use a stronger password.';
      case 'invalid-verification-code':
        return 'Invalid verification code entered. Please check and try again.';
      case 'invalid-verification-id':
      case 'session-expired':
        return 'Verification session has expired. Please request a new OTP.';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again in a few minutes.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again after some time.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'invalid-phone-number':
        return 'Please enter a valid 10-digit mobile number.';
      case 'missing-phone-number':
        return 'Mobile number is required.';
      default:
        if (message != null && message.trim().isNotEmpty && !message.contains('Exception:')) {
          return message.trim();
        }
        return fallback;
    }
  }
}
