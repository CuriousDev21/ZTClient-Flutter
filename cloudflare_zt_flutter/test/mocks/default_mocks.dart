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

// Fallback values registration for complex objects
void registerFallbackValues() {
  registerFallbackValue(FakeAuthToken());
}

// Centralized Mock Setup Function
Future<void> setupDefaultMocksBehavior() async {
  // Register fallback values
  registerFallbackValues();

  // Initialize mocks
  mockSocket = MockTSocket();
  mockSocketService = MockSocketService();
  mockStreamSubscription = MockStreamSubscription();

  // Mock SocketService behavior
  when(() => mockSocketService.connect(any())).thenAnswer((_) async {});
  when(() => mockSocketService.disconnect()).thenAnswer((_) async {});
  when(() => mockSocketService.getStatus()).thenAnswer((_) async => const DaemonStatus.connected());

  // Mock SecureStorageService behavior
  mockSecureStorageService = MockSecureStorageService();
  when(() => mockSecureStorageService.read(key: any(named: 'key'))).thenAnswer((_) async => null);
  when(() => mockSecureStorageService.write(key: any(named: 'key'), value: any(named: 'value')))
      .thenAnswer((_) async {});
  when(() => mockSecureStorageService.delete(key: any(named: 'key'))).thenAnswer((_) async {});

  // Mock AuthService behavior
  mockAuthService = MockAuthService();
  when(() => mockAuthService.getAuthToken())
      .thenAnswer((_) async => AuthToken(token: '245346444925233', timestamp: DateTime.now()));

  // Mock TokenRepository
  mockTokenRepository = MockTokenRepository();
  when(() => mockTokenRepository.getAuthToken())
      .thenAnswer((_) async => AuthToken(token: '245346444925233', timestamp: DateTime.now()));
  when(() => mockTokenRepository.cacheAuthToken(any())).thenAnswer((_) async {});
  when(() => mockTokenRepository.discardToken()).thenAnswer((_) async {});
}

// Mocking Socket behavior
void mockSocketBehavior(MockTSocket mockSocket) {
  mockStreamSubscription = MockStreamSubscription();

  // Mock the listen method to trigger the response with data
  when(() => mockSocket.listen(any(), onError: any(named: 'onError'), onDone: any(named: 'onDone')))
      .thenAnswer((invocation) {
    final callback = invocation.positionalArguments[0] as void Function(Uint8List);

    // Simulate the daemon response after the connection
    final mockResponse = json.encode({
      "status": "success",
      "data": {"daemon_status": "connected"}
    });

    // Trigger the callback with the simulated response
    callback(Uint8List.fromList(utf8.encode(mockResponse)));

    return mockStreamSubscription;
  });

  // Mock the subscription cancellation
  when(() => mockStreamSubscription.cancel()).thenAnswer((_) async {});

  // Mock the lifecycle methods
  when(() => mockSocket.add(any())).thenAnswer((_) async {});
  when(() => mockSocket.flush()).thenAnswer((_) async {});
}

// Mocking Socket.connect behavior
void mockSocketConnect() {
  // Simulate Socket.connect behavior to return a mock socket.
  mockConnect = (InternetAddress address, int port) async => mockSocket;
}
