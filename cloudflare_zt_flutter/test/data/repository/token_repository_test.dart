import 'dart:async';

import 'package:cloudflare_zt_flutter/application/services/secure_storage_service.dart';
import 'package:cloudflare_zt_flutter/data/repositories/token_repository.dart';
import 'package:cloudflare_zt_flutter/domain/models/auth/auth_token.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/default_mocks.dart';

void main() {
  late TokenRepository tokenRepository;
  late MockSecureStorageService mockSecureStorageService;

  // Set up before each test
  setUp(() {
    mockSecureStorageService = MockSecureStorageService();
    tokenRepository = TokenRepository(mockSecureStorageService);
  });

  // Group the tests under TokenRepository
  group('TokenRepository Tests', () {
    const String testToken = 'test_auth_token';
    final DateTime testTimestamp = DateTime.now();

    test('Cache a new token and verify it is stored', () async {
      final authToken = AuthToken(token: testToken, timestamp: testTimestamp);

      when(() => mockSecureStorageService.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      await tokenRepository.cacheAuthToken(authToken);

      verify(() => mockSecureStorageService.write(key: SecureStorageKeys.authToken, value: testToken)).called(1);
      verify(() => mockSecureStorageService.write(
          key: SecureStorageKeys.tokenTimestamp, value: testTimestamp.toIso8601String())).called(1);
    });

    test('Retrieve valid token from storage', () async {
      when(() => mockSecureStorageService.read(key: SecureStorageKeys.authToken)).thenAnswer((_) async => testToken);
      when(() => mockSecureStorageService.read(key: SecureStorageKeys.tokenTimestamp))
          .thenAnswer((_) async => testTimestamp.toIso8601String());

      final authToken = await tokenRepository.getAuthToken();

      expect(authToken?.token, testToken);
      expect(authToken?.timestamp, testTimestamp);
    });

    test('Retrieve expired token and ensure it is discarded', () async {
      final expiredTimestamp = DateTime.now().subtract(const Duration(minutes: 6));

      when(() => mockSecureStorageService.read(key: SecureStorageKeys.authToken)).thenAnswer((_) async => testToken);
      when(() => mockSecureStorageService.read(key: SecureStorageKeys.tokenTimestamp))
          .thenAnswer((_) async => expiredTimestamp.toIso8601String());
      when(() => mockSecureStorageService.delete(key: any(named: 'key'))).thenAnswer((_) async {});

      final authToken = await tokenRepository.getAuthToken();

      expect(authToken, null); // Expect the token to be null since it's expired
      verify(() => mockSecureStorageService.delete(key: SecureStorageKeys.authToken)).called(1);
      verify(() => mockSecureStorageService.delete(key: SecureStorageKeys.tokenTimestamp)).called(1);
    });

    test('Discard token immediately after successful connection', () async {
      when(() => mockSecureStorageService.delete(key: any(named: 'key'))).thenAnswer((_) async {});

      await tokenRepository.onSuccessfulConnection();

      verify(() => mockSecureStorageService.delete(key: SecureStorageKeys.authToken)).called(1);
      verify(() => mockSecureStorageService.delete(key: SecureStorageKeys.tokenTimestamp)).called(1);
    });
    test('Token should expire after defined interval', () async {
      final testCompleter = Completer<void>();
      final authToken = AuthToken(token: testToken, timestamp: testTimestamp);

      // Use a shorter expiration duration (e.g., 2 seconds) for testing
      final shortExpirationRepository = TokenRepository(
        mockSecureStorageService,
        expirationDuration: const Duration(seconds: 2),
      );

      // Ensure write method behaves as expected
      when(() => mockSecureStorageService.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      // Ensure delete method completes the test, but only once for both keys
      var deleteAuthTokenCalled = false;
      var deleteTokenTimestampCalled = false;

      // Mock the delete behavior for both keys
      when(() => mockSecureStorageService.delete(key: any(named: 'key'))).thenAnswer((invocation) async {
        final key = invocation.namedArguments[const Symbol('key')] as String;

        // Track which key is being deleted
        if (key == SecureStorageKeys.authToken) {
          deleteAuthTokenCalled = true;
        } else if (key == SecureStorageKeys.tokenTimestamp) {
          deleteTokenTimestampCalled = true;
        }

        // Complete the test when both deletes are called
        if (deleteAuthTokenCalled && deleteTokenTimestampCalled) {
          testCompleter.complete();
        }
      });

      // Cache the token
      await shortExpirationRepository.cacheAuthToken(authToken);

      // Wait for the token to expire (this will ensure that the Completer gets completed when both deletes happen)
      await testCompleter.future;

      // Verify that both delete calls were made for 'auth_token' and 'token_timestamp'
      verify(() => mockSecureStorageService.delete(key: SecureStorageKeys.authToken)).called(1);
      verify(() => mockSecureStorageService.delete(key: SecureStorageKeys.tokenTimestamp)).called(1);
    });
  });
}
