import 'dart:async';

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
  Timer? _tokenExpiryTimer;
  final Duration _expirationDuration;

  TokenRepository(this._secureStorageService, {Duration? expirationDuration})
      : _expirationDuration = expirationDuration ?? const Duration(minutes: 5);

  // Get the auth token from storage or return null if not found or expired
  Future<AuthToken?> getAuthToken() async {
    final token = await _secureStorageService.read(key: SecureStorageKeys.authToken);
    final timestampString = await _secureStorageService.read(key: SecureStorageKeys.tokenTimestamp);

    if (token == null || timestampString == null) {
      logger.info("No auth token or timestamp found in persistence storage.");
      return null;
    }

    final authToken = AuthToken(token: token, timestamp: DateTime.parse(timestampString));

    if (authToken.isExpired()) {
      logger.info("Auth token has expired. Discarding.");
      await discardToken();
      return null;
    }

    // Set timer to discard token after remaining time
    _startTokenExpiryTimer(_calculateRemainingDuration(authToken));
    logger.info("Auth token valid until ${authToken.timestamp.add(_expirationDuration)}");

    return authToken;
  }

  // Cache a new auth token and start the expiration timer
  Future<void> cacheAuthToken(AuthToken authToken) async {
    logger.info("Caching new auth token.");
    await _secureStorageService.write(key: SecureStorageKeys.authToken, value: authToken.token);
    await _secureStorageService.write(
        key: SecureStorageKeys.tokenTimestamp, value: authToken.timestamp.toIso8601String());

    // Set expiration timer for 5 minutes
    _startTokenExpiryTimer(_expirationDuration);
  }

  // Discard the cached token and cancel the expiration timer
  Future<void> discardToken() async {
    logger.info("Discarding auth token.");
    await _secureStorageService.delete(key: SecureStorageKeys.authToken);
    await _secureStorageService.delete(key: SecureStorageKeys.tokenTimestamp);
    _cancelTokenExpiryTimer();
  }

  // Handle token discard after a successful connection
  Future<void> onSuccessfulConnection() async {
    logger.info("Connection successful. Discarding auth token.");
    await discardToken();
  }

  // Set a timer to discard the token after the given duration
  void _startTokenExpiryTimer(Duration expirationDuration) {
    _cancelTokenExpiryTimer(); // Cancel any previous timer

    _tokenExpiryTimer = Timer(expirationDuration, () async {
      logger.info("Auth token has expired after $expirationDuration.");
      await discardToken();
    });
  }

  // Cancel the token expiration timer
  void _cancelTokenExpiryTimer() {
    _tokenExpiryTimer?.cancel();
    _tokenExpiryTimer = null;
  }

  // Calculate the remaining time until the token expires
  Duration _calculateRemainingDuration(AuthToken authToken) {
    final expirationTime = authToken.timestamp.add(_expirationDuration);
    return expirationTime.isBefore(DateTime.now()) ? Duration.zero : expirationTime.difference(DateTime.now());
  }
}
