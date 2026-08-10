import 'package:flutter_test/flutter_test.dart';
import 'package:payout/core/error/error_message_mapper.dart';
import 'package:payout/core/network/network_exception.dart';

void main() {
  group('ErrorMessageMapper Unit Tests', () {
    test('maps NetworkException unauthorized status code to standard message', () {
      const err = NetworkException('Session expired', statusCode: 401, type: NetworkExceptionType.unauthorized);
      final msg = ErrorMessageMapper.map(err);
      expect(msg, equals('Your session has expired. Please sign in again.'));
    });

    test('maps NetworkException forbidden status code to standard message', () {
      const err = NetworkException('Forbidden resource', statusCode: 403, type: NetworkExceptionType.forbidden);
      final msg = ErrorMessageMapper.map(err);
      expect(msg, equals('You do not have permission to perform this action.'));
    });

    test('maps NetworkException notFound status code to standard message', () {
      const err = NetworkException('Asset missing', statusCode: 404, type: NetworkExceptionType.notFound);
      final msg = ErrorMessageMapper.map(err);
      expect(msg, equals('The requested information was not found.'));
    });

    test('maps NetworkException validationError directly to its custom validation message', () {
      const err = NetworkException('UPI ID format is incorrect', statusCode: 422, type: NetworkExceptionType.validationError);
      final msg = ErrorMessageMapper.map(err);
      expect(msg, equals('UPI ID format is incorrect'));
    });

    test('maps NetworkException timeout and networkError to user-friendly offline message', () {
      const timeoutErr = NetworkException('Request timed out', type: NetworkExceptionType.timeout);
      expect(ErrorMessageMapper.map(timeoutErr), equals('Unable to connect. Please check your internet connection.'));

      const netErr = NetworkException('Network failed', type: NetworkExceptionType.networkError);
      expect(ErrorMessageMapper.map(netErr), equals('Unable to connect. Please check your internet connection.'));
    });

    test('maps NetworkException serverError to standard server problem message', () {
      const err = NetworkException('Internal crash', statusCode: 500, type: NetworkExceptionType.serverError);
      final msg = ErrorMessageMapper.map(err);
      expect(msg, equals('Our servers are experiencing issues. Please try again shortly.'));
    });

    test('falls back to custom message or generic fallback for unknown exceptions', () {
      expect(ErrorMessageMapper.map('Connection aborted'), equals('Connection aborted'));
      expect(ErrorMessageMapper.map(Exception('Custom exception details')), equals('Custom exception details'));
      expect(ErrorMessageMapper.map(null), equals('Something went wrong. Please try again.'));
    });
  });
}
