import 'dart:async';

import 'package:cloudflare_zt_flutter/application/services/secure_storage_service.dart';
import 'package:cloudflare_zt_flutter/core/utils/logger/app_logger.dart';
import 'package:cloudflare_zt_flutter/domain/models/auth/auth_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final tokenRepositoryProvider = Provider<TokenRepository>((ref) {
  final secureStorage = ref.read(secureStorageServiceProvider);
  return TokenRepository(secureStorage);
});

/// Repository responsible for handling the storage and expiration of the authentication token.
///
/// The [TokenRepository] manages caching, retrieving, and discarding the
/// authentication token, along with handling the expiration logic.
class TokenRepository {
  final SecureStorageService _secureStorageService;
  Timer? _tokenExpiryTimer;
  final Duration _expirationDuration;

  /// Creates a new instance of [TokenRepository] using the provided
  /// [SecureStorageService] and optional expiration duration.
  ///
  /// If no [expirationDuration] is provided, it defaults to 5 minutes.
  TokenRepository(this._secureStorageService, {Duration? expirationDuration})
      : _expirationDuration = expirationDuration ?? const Duration(minutes: 5);

  /// Retrieves the cached authentication token if it is not expired.
  ///
  /// If the token is expired or not found, it returns `null`.
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

    _startTokenExpiryTimer(_calculateRemainingDuration(authToken));
    logger.info("Auth token valid until ${authToken.timestamp.add(_expirationDuration)}");

    return authToken;
  }

  /// Caches a new authentication token and starts the expiration timer.
  Future<void> cacheAuthToken(AuthToken authToken) async {
    logger.info("Caching new auth token.");
    await _secureStorageService.write(key: SecureStorageKeys.authToken, value: authToken.token);
    await _secureStorageService.write(
        key: SecureStorageKeys.tokenTimestamp, value: authToken.timestamp.toIso8601String());

    _startTokenExpiryTimer(_expirationDuration);
  }

  /// Discards the cached authentication token and cancels the expiration timer.
  Future<void> discardToken() async {
    logger.info("Discarding auth token.");
    await _secureStorageService.delete(key: SecureStorageKeys.authToken);
    await _secureStorageService.delete(key: SecureStorageKeys.tokenTimestamp);
    _cancelTokenExpiryTimer();
  }

  /// Cancels the token expiration timer, if active.
  void _cancelTokenExpiryTimer() {
    _tokenExpiryTimer?.cancel();
    _tokenExpiryTimer = null;
  }

  /// Starts a timer to discard the token after the given duration.
  void _startTokenExpiryTimer(Duration expirationDuration) {
    _cancelTokenExpiryTimer();

    _tokenExpiryTimer = Timer(expirationDuration, () async {
      logger.info("Auth token has expired after $expirationDuration.");
      await discardToken();
    });
  }

  /// Calculates the remaining duration before the token expires.
  Duration _calculateRemainingDuration(AuthToken authToken) {
    final expirationTime = authToken.timestamp.add(_expirationDuration);
    return expirationTime.isBefore(DateTime.now()) ? Duration.zero : expirationTime.difference(DateTime.now());
  }
}
