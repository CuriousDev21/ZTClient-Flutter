// Mock Classes
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloudflare_zt_flutter/application/services/auth_service.dart';
import 'package:cloudflare_zt_flutter/application/services/secure_storage_service.dart';
import 'package:cloudflare_zt_flutter/application/services/socket_service.dart';
import 'package:cloudflare_zt_flutter/data/repositories/token_repository.dart';
import 'package:cloudflare_zt_flutter/domain/models/auth/auth_token.dart';
import 'package:cloudflare_zt_flutter/domain/models/daemon/daemon_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes

// Mock classes
class MockTokenRepository extends Mock implements TokenRepository {}

class MockAuthService extends Mock implements AuthService {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockSocketService extends Mock implements SocketService {}

class MockTSocket extends Mock implements Socket {}

class MockDaemonStatus extends Mock implements DaemonStatus {}

class FakeAuthToken extends Fake implements AuthToken {}

class MockStreamSubscription extends Mock implements StreamSubscription<Uint8List> {}

// Declare global variables for mocks
late MockSocketService mockSocketService;
late MockSecureStorageService mockSecureStorageService;
late MockAuthService mockAuthService;
late MockTokenRepository mockTokenRepository;
late MockDaemonStatus mockDaemonStatus;
late MockStreamSubscription mockStreamSubscription;
late MockTSocket mockSocket;
late Future<Socket> Function(InternetAddress, int) mockConnect;

// Fallback values registration
void registerFallbackValues() {
  registerFallbackValue(FakeAuthToken());
}

// Setup behavior for each mock group
Future<void> setupMockSocketService() async {
  mockSocketService = MockSocketService();
  when(() => mockSocketService.connect(any())).thenAnswer((_) async {});
  when(() => mockSocketService.disconnect()).thenAnswer((_) async {});
  when(() => mockSocketService.getStatus()).thenAnswer((_) async => const DaemonStatus.connected());
}

Future<void> setupMockSecureStorageService() async {
  mockSecureStorageService = MockSecureStorageService();
  when(() => mockSecureStorageService.read(key: any(named: 'key'))).thenAnswer((_) async => null);
  when(() => mockSecureStorageService.write(key: any(named: 'key'), value: any(named: 'value')))
      .thenAnswer((_) async {});
  when(() => mockSecureStorageService.delete(key: any(named: 'key'))).thenAnswer((_) async {});
}

Future<void> setupMockAuthService() async {
  mockAuthService = MockAuthService();
  when(() => mockAuthService.getRemoteAuthToken())
      .thenAnswer((_) async => AuthToken(token: '245346444925233', timestamp: DateTime.now()));
}

Future<void> setupMockTokenRepository() async {
  mockTokenRepository = MockTokenRepository();
  when(() => mockTokenRepository.getAuthToken())
      .thenAnswer((_) async => AuthToken(token: '245346444925233', timestamp: DateTime.now()));
  when(() => mockTokenRepository.cacheAuthToken(any())).thenAnswer((_) async {});
  when(() => mockTokenRepository.discardToken()).thenAnswer((_) async {});
}

// Centralized mock behavior setup
Future<void> setupDefaultMocksBehavior() async {
  registerFallbackValues();
  await setupMockSocketService();
  await setupMockSecureStorageService();
  await setupMockAuthService();
  await setupMockTokenRepository();
}

// Mock Socket behavior
void mockSocketBehavior() {
  mockStreamSubscription = MockStreamSubscription();

  when(() => mockSocket.listen(any(), onError: any(named: 'onError'), onDone: any(named: 'onDone')))
      .thenAnswer((invocation) {
    final callback = invocation.positionalArguments[0] as void Function(Uint8List);

    final mockResponse = json.encode({
      "status": "success",
      "data": {"daemon_status": "connected"}
    });

    callback(Uint8List.fromList(utf8.encode(mockResponse)));

    return mockStreamSubscription;
  });

  when(() => mockStreamSubscription.cancel()).thenAnswer((_) async {});
  when(() => mockSocket.add(any())).thenAnswer((_) async {});
  when(() => mockSocket.flush()).thenAnswer((_) async {});
}

// Mock Socket.connect behavior
void mockSocketConnect() {
  mockSocket = MockTSocket();
  mockConnect = (InternetAddress address, int port) async => mockSocket;
}

// Use this function in test files to set up the mocks
void setUpMocks() {
  setUpAll(() async {
    await setupDefaultMocksBehavior();
  });
}
