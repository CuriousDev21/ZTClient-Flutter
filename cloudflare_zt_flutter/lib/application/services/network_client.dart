import 'package:cloudflare_zt_flutter/core/utils/logger/app_logger.dart';
import 'package:cloudflare_zt_flutter/domain/errors/network_exception.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final remoteDataSourceProvider = Provider<NetworkClient>((ref) => NetworkClient());

/// A network client responsible for making REST API requests using the Dio library.
///
/// [NetworkClient] supports various HTTP methods such as GET, POST, PUT, DELETE, and PATCH.
class NetworkClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://warp-registration.warpdir2792.workers.dev/',
      receiveTimeout: const Duration(minutes: 1),
    ),
  )..interceptors.addAll([LogInterceptor(responseHeader: false, responseBody: true)]);

  final CancelToken cancelToken = CancelToken();

  /// Invokes an API request with the specified [url], [requestType], and optional parameters.
  ///
  /// Throws [DioNetworkingException] if an error occurs during the request.
  Future<Response> invoke(
    String url,
    RequestType requestType, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    dynamic requestBody,
    Options? options,
  }) async {
    options ??= Options(responseType: ResponseType.json);

    if (headers != null) {
      options.headers = headers;
    }

    try {
      return switch (requestType) {
        RequestType.get =>
          await dio.get(url, queryParameters: queryParameters, options: options, cancelToken: cancelToken),
        RequestType.post => await dio.post(url,
            data: requestBody, queryParameters: queryParameters, options: options, cancelToken: cancelToken),
        RequestType.put => await dio.put(url, data: requestBody, options: options, cancelToken: cancelToken),
        RequestType.delete => await dio.delete(url,
            queryParameters: queryParameters, data: requestBody, options: options, cancelToken: cancelToken),
        RequestType.patch => await dio.patch(url,
            data: requestBody, queryParameters: queryParameters, options: options, cancelToken: cancelToken),
      };
    } on DioException catch (e) {
      logger.error("Error during $requestType request to $url: ${e.message}");
      throw DioNetworkingException.fromDioException(e);
    }
  }

  /// Cancels any ongoing API requests.
  void cancelRequests() {
    logger.info("Cancelling all requests.");
    cancelToken.cancel("Request was cancelled");
  }
}

// Types used by invoke API.
enum RequestType { get, post, put, delete, patch }

class APIResponseCodes {
  static const int ok = 200;
  static const int multipleChoices = 300;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int internalServerError = 500;
}
