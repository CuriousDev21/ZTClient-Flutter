import 'package:cloudflare_zt_flutter/application/services/secure_storage_service.dart';
import 'package:cloudflare_zt_flutter/core/utils/logger/app_logger.dart';
import 'package:cloudflare_zt_flutter/domain/models/auth/auth_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final tokenRepositoryProvider = Provider<TokenRepository>((ref) {
  final secureStorage = ref.read(secureStorageServiceProvider);
  return TokenRepository(secureStorage);
});

class TokenRepository {
  final SecureStorageService _secureStorageService;

  TokenRepository(this._secureStorageService);

  Future<AuthToken?> getAuthToken() async {
    final token = await _secureStorageService.read(key: SecureStorageKeys.authToken);
    final timestampString = await _secureStorageService.read(key: SecureStorageKeys.tokenTimestamp);
    if (token == null || timestampString == null) {
      logger.info("No auth token or timestamp found in secure storage.");
      return null;
    }

    final timestamp = DateTime.parse(timestampString);
    final authToken = AuthToken(token: token, timestamp: timestamp);
    if (authToken.isExpired()) {
      logger.info("Auth token has expired. Discarding token.");
      await discardToken();
      return null;
    }

    logger
        .info("Auth token retrieved from secure storage and valid until ${timestamp.add(const Duration(minutes: 5))}");
    return authToken;
  }

  Future<void> cacheAuthToken(AuthToken authToken) async {
    logger.info("Caching new auth token.");
    await _secureStorageService.write(key: SecureStorageKeys.authToken, value: authToken.token);
    await _secureStorageService.write(
        key: SecureStorageKeys.tokenTimestamp, value: authToken.timestamp.toIso8601String());
  }

  Future<void> discardToken() async {
    logger.info("Discarding auth token.");
    await _secureStorageService.delete(key: SecureStorageKeys.authToken);
    await _secureStorageService.delete(key: SecureStorageKeys.tokenTimestamp);
  }
}
