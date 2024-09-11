import 'package:cloudflare_zt_flutter/domain/errors/network_exception.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_source_exception.freezed.dart';

@freezed
class DataSourceException with _$DataSourceException {
  const factory DataSourceException.serverError({String? message}) = _ServerException;
  const factory DataSourceException.connection({String? message}) = _ConnectionException;
  const factory DataSourceException.unauthorized({String? message}) = _UnauthorizedException;
  const factory DataSourceException.forbidden({String? message}) = _ForbiddenException;
  const factory DataSourceException.unknown({String? message}) = _UnknownException;
  const factory DataSourceException.busy({String? message}) = _BusyException;

  /// Creates a DataSourceException based on DioNetworkingException
  static DataSourceException fromDio(DioNetworkingException exception) {
    final message = exception.message;

    if ((exception.dioErrorType == DioExceptionType.unknown && exception.statusCode == null) ||
        exception.dioErrorType == DioExceptionType.connectionTimeout ||
        exception.dioErrorType == DioExceptionType.sendTimeout ||
        exception.dioErrorType == DioExceptionType.receiveTimeout) {
      return DataSourceException.connection(message: message);
    }

    return switch (exception.statusCode) {
      APIResponseCodes.unauthorized => DataSourceException.unauthorized(message: message),
      _ => DataSourceException.unknown(message: message),
    };
  }

  static DataSourceException fromDaemonResponse(Map<String, dynamic> response) {
    final status = response['status'];
    final message = response['message'] ?? 'Unknown error';

    switch (status) {
      case 'error':
        if (message.contains('busy')) {
          return DataSourceException.busy(message: message);
        }
        return DataSourceException.serverError(message: message);
      default:
        return DataSourceException.unknown(message: message);
    }
  }
}

class APIResponseCodes {
  static const ok = 200;
  static const multipleChoices = 300;
  static const badRequest = 400;
  static const unauthorized = 401;
  static const forbidden = 403;
  static const notFound = 404;
  static const internalServerError = 500;
}