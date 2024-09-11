import 'dart:convert';

import 'package:cloudflare_zt_flutter/application/services/secure_storage_service.dart';
import 'package:cloudflare_zt_flutter/domain/models/auth/auth_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final tokenRepositoryProvider = Provider<TokenRepository>((ref) {
  final secureStorage = ref.read(secureStorageServiceProvider);
  return TokenRepository(secureStorage);
});

class TokenRepository {
  final SecureStorageService _storageService;

  TokenRepository(this._storageService);

  Future<void> storeAuthToken(AuthToken token) async {
    await _storageService.write(key: SecureStorageKeys.authToken, value: json.encode(token.toJson()));
    await _storageService.write(key: SecureStorageKeys.tokenTimestamp, value: token.timestamp.toIso8601String());
  }

  Future<AuthToken?> getAuthToken() async {
    final tokenString = await _storageService.read(key: SecureStorageKeys.authToken);
    final timestampString = await _storageService.read(key: SecureStorageKeys.tokenTimestamp);
    if (tokenString == null || timestampString == null) return null;

    final authToken = AuthToken.fromJson(json.decode(tokenString));
    if (authToken.isExpired()) {
      await discardToken();
      return null;
    }
    return authToken;
  }

  Future<void> discardToken() async {
    await _storageService.delete(key: SecureStorageKeys.authToken);
    await _storageService.delete(key: SecureStorageKeys.tokenTimestamp);
  }
}
