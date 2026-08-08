/// Standard API Response Wrapper
class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool success;
  final int? statusCode;

  const ApiResponse({
    this.data,
    this.message,
    required this.success,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {String? message, int? statusCode}) {
    return ApiResponse(
      data: data,
      message: message,
      success: true,
      statusCode: statusCode ?? 200,
    );
  }

  factory ApiResponse.error(String message, {int? statusCode, T? data}) {
    return ApiResponse(
      data: data,
      message: message,
      success: false,
      statusCode: statusCode ?? 400,
    );
  }

  bool get hasData => data != null;
}
