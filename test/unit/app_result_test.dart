import 'package:flutter_test/flutter_test.dart';
import 'package:payout/core/result/app_result.dart';

void main() {
  group('AppResult Unit Tests', () {
    test('AppResult.success wraps data and message correctly', () {
      final res = AppResult.success('test_data', message: 'Loaded successfully', statusCode: 201);

      expect(res.isSuccess, isTrue);
      expect(res.isFailure, isFalse);
      expect(res.data, equals('test_data'));
      expect(res.message, equals('Loaded successfully'));
      expect(res.statusCode, equals(201));
      expect(res.hasData, isTrue);
    });

    test('AppResult.failure wraps error details correctly', () {
      final exception = Exception('Request timeout');
      final res = AppResult<String>.failure(exception, message: 'Timeout error', statusCode: 408);

      expect(res.isSuccess, isFalse);
      expect(res.isFailure, isTrue);
      expect(res.error, equals(exception));
      expect(res.message, equals('Timeout error'));
      expect(res.statusCode, equals(408));
      expect(res.hasData, isFalse);
    });

    test('AppResult.when maps success and failure blocks cleanly', () {
      final successResult = AppResult.success(100);
      final mappedSuccess = successResult.when(
        success: (val) => 'Value: $val',
        failure: (err, msg) => 'Failed: $msg',
      );
      expect(mappedSuccess, equals('Value: 100'));

      final failureResult = AppResult<int>.failure(Exception('Network error'), message: 'Failed connection');
      final mappedFailure = failureResult.when(
        success: (val) => 'Value: $val',
        failure: (err, msg) => 'Failed: $msg',
      );
      expect(mappedFailure, equals('Failed: Failed connection'));
    });

    test('AppResult.map transforms data payload type', () {
      final initial = AppResult.success(42);
      final transformed = initial.map((val) => 'Answer is $val');

      expect(transformed.isSuccess, isTrue);
      expect(transformed.data, equals('Answer is 42'));
    });
  });
}
