import 'package:cloudflare_zt_flutter/application/services/secure_storage_service.dart';
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
    if (token == null || timestampString == null) return null;
    final timestamp = DateTime.parse(timestampString);
    final authToken = AuthToken(token: token, timestamp: timestamp);
    return authToken.isExpired() ? null : authToken;
  }

  Future<void> cacheAuthToken(AuthToken authToken) async {
    await _secureStorageService.write(key: SecureStorageKeys.authToken, value: authToken.token);
    await _secureStorageService.write(
        key: SecureStorageKeys.tokenTimestamp, value: authToken.timestamp.toIso8601String());
  }

  Future<void> discardToken() async {
    await _secureStorageService.delete(key: SecureStorageKeys.authToken);
    await _secureStorageService.delete(key: SecureStorageKeys.tokenTimestamp);
  }
}
