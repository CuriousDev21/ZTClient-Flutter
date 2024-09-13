import 'package:cloudflare_zt_flutter/application/services/api_config.dart';
import 'package:cloudflare_zt_flutter/application/services/network_client.dart';
import 'package:cloudflare_zt_flutter/core/utils/logger/app_logger.dart';
import 'package:cloudflare_zt_flutter/domain/errors/data_source_exception.dart';
import 'package:cloudflare_zt_flutter/domain/errors/network_exception.dart';
import 'package:cloudflare_zt_flutter/domain/models/auth/auth_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final networkClient = ref.read(remoteDataSourceProvider);
  return AuthService(networkClient);
});

class AuthService {
  final NetworkClient _networkClient;

  AuthService(this._networkClient);

  Future<AuthToken> getRemoteAuthToken() async {
    try {
      final response = await _networkClient.invoke(
        APIEndpoints.registration,
        RequestType.get,
        headers: {
          'X-Auth-Key': '3735928559',
        },
      );
      logger.info("Successfully fetched new auth token from the server.");
      return AuthToken(
        token: response.data['data']['auth_token'].toString(),
        timestamp: DateTime.now(),
      );
    } on DioNetworkingException catch (e) {
      logger.error("Registration failed: ${e.message}");
      throw DataSourceException.fromDio(e);
    }
  }
}
