/// Generic Result pattern implementation for repository and domain service operations.
class AppResult<T> {
  final T? data;
  final Object? error;
  final String? message;
  final int? statusCode;
  final bool isSuccess;

  const AppResult._({
    this.data,
    this.error,
    this.message,
    this.statusCode,
    required this.isSuccess,
  });

  /// Successful result containing domain data
  factory AppResult.success(T data, {String? message, int? statusCode}) {
    return AppResult._(
      data: data,
      message: message,
      statusCode: statusCode ?? 200,
      isSuccess: true,
    );
  }

  /// Failed result containing error details
  factory AppResult.failure(Object error, {String? message, int? statusCode}) {
    return AppResult._(
      error: error,
      message: message,
      statusCode: statusCode ?? 400,
      isSuccess: false,
    );
  }

  bool get isFailure => !isSuccess;
  bool get hasData => data != null;

  /// Fold/pattern match on success or failure
  R when<R>({
    required R Function(T data) success,
    required R Function(Object error, String message) failure,
  }) {
    if (isSuccess && data != null) {
      return success(data as T);
    }
    return failure(error ?? Exception('Unknown error'), message ?? 'An unexpected error occurred.');
  }

  /// Map data to a new type
  AppResult<R> map<R>(R Function(T data) transform) {
    if (isSuccess && data != null) {
      return AppResult.success(transform(data as T), message: message, statusCode: statusCode);
    }
    return AppResult.failure(error ?? Exception('Unknown error'), message: message, statusCode: statusCode);
  }
}
