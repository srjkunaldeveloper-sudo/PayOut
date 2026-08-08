enum NetworkExceptionType {
  unauthorized,
  forbidden,
  notFound,
  validationError,
  serverError,
  networkError,
  timeout,
  unknown,
}

class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final NetworkExceptionType type;

  const NetworkException(
    this.message, {
    this.statusCode,
    this.type = NetworkExceptionType.unknown,
  });

  factory NetworkException.fromStatusCode(int? statusCode, String message) {
    NetworkExceptionType type;
    switch (statusCode) {
      case 401:
        type = NetworkExceptionType.unauthorized;
        break;
      case 403:
        type = NetworkExceptionType.forbidden;
        break;
      case 404:
        type = NetworkExceptionType.notFound;
        break;
      case 422:
      case 400:
        type = NetworkExceptionType.validationError;
        break;
      case 500:
      case 502:
      case 503:
      case 504:
        type = NetworkExceptionType.serverError;
        break;
      default:
        type = NetworkExceptionType.unknown;
    }
    return NetworkException(message, statusCode: statusCode, type: type);
  }

  @override
  String toString() => 'NetworkException: $message (Status: $statusCode, Type: $type)';
}
