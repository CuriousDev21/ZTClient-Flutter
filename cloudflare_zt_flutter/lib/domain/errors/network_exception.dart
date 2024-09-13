// path: lib/domain/errors/dio_networking_exception.dart
import 'package:dio/dio.dart';

/// Exception thrown by Dio networking
/// - [DioNetworkingException] when there is a networking error
/// - [DioExceptionType] when the error type is known
///  - [DioExceptionType.cancel] when the request is cancelled
/// - [DioExceptionType.connectTimeout] when the connection times out
/// - [DioExceptionType.receiveTimeout] when the response times out
/// - [DioExceptionType.sendTimeout] when the request times out
/// - [DioExceptionType.response] when the response is invalid
/// - [DioExceptionType.other] when the error is unknown
/// - [DioExceptionType.unknown] when the error is unknown
class DioNetworkingException implements Exception {
  final String message;
  final int? statusCode;
  final DioExceptionType? dioErrorType;

  DioNetworkingException({required this.message, this.statusCode, this.dioErrorType});

  factory DioNetworkingException.fromDioException(DioException dioException) {
    // Extract the status code and type directly
    final int? statusCode = dioException.response?.statusCode;
    final DioExceptionType dioErrorType = dioException.type;

    // Default to Dio's message, then try to improve it if possible
    String message = dioException.toString();
    final responseData = dioException.response?.data;

    // If there's a response and it contains error details, use that message
    if (dioErrorType == DioExceptionType.unknown && dioException.error != null) {
      message = dioException.error.toString();
    } else if (responseData is Map) {
      final String? detailedError =
          responseData['error_description'] ?? responseData['error'] ?? responseData['message'];
      message = detailedError ?? message;
    }

    return DioNetworkingException(
      message: message,
      statusCode: statusCode,
      dioErrorType: dioErrorType,
    );
  }
}
