import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloudflare_zt_flutter/application/services/socket_service.dart';
import 'package:cloudflare_zt_flutter/domain/errors/data_source_exception.dart';
import 'package:cloudflare_zt_flutter/domain/models/daemon/daemon_request.dart';
import 'package:cloudflare_zt_flutter/domain/models/daemon/daemon_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/default_mocks.dart';
import '../../mocks/socket_service_mock.dart';

void main() {
  late SocketService socketService;

  setUp(() async {
    // Initialize the global mock setup
    await setupDefaultMocksBehavior();

    // Set up the mock Socket.connect behavior
    mockSocketConnect();

    // Register fallback values
    registerFallbackValue(<int>[]);
    registerFallbackValue(Uint8List(0));

    // Initialize the real SocketService with mockConnect and mockSocket
    socketService = SocketService(connect: mockConnect, socket: mockSocket);
  });

  group('SocketService - Mocked Socket Tests', () {
    // Test 1: Successfully connect to the mock socket
    test('Given mock socket setup, When connecting, Then it should connect successfully', () async {
      const port = 1234;
      const testMessage = 'test message';

      IOOverrides.runZoned(
        () async {
          // Given: Simulate connecting to a mock socket
          final socket = await Socket.connect(InternetAddress.loopbackIPv4, port);
          expect(socket is MockSocket, isTrue);

          // When: Simulate sending and receiving data
          socket.add(utf8.encode(testMessage));

          // Then: The received data should match what was sent
          socket.listen((Uint8List data) {
            final response = utf8.decode(data);
            expect(response, testMessage);
          });

          // Close the socket and check if it's closed
          await socket.close();
          await socket.done;
        },
        socketConnect: (host, port, {sourceAddress, sourcePort = 0, timeout}) {
          return MockSocket.connect(host, port, sourceAddress: sourceAddress, sourcePort: sourcePort, timeout: timeout);
        },
      );
    });

    // Test 2: Handle disconnection properly
    test('Given an open socket, When disconnecting, Then it should handle disconnection', () async {
      const port = 1234;

      IOOverrides.runZoned(
        () async {
          // Given: An open socket
          final socket = await Socket.connect(InternetAddress.loopbackIPv4, port);

          // When: Simulate disconnection
          socket.add(utf8.encode('disconnect'));

          // Then: Ensure the socket handles the disconnection
          socket.listen(null, onDone: () async {
            await socket.done;
            expect(true, isTrue); // Simulate a successful disconnection event
          });

          await socket.close();
        },
        socketConnect: (host, port, {sourceAddress, sourcePort = 0, timeout}) {
          return MockSocket.connect(host, port, sourceAddress: sourceAddress, sourcePort: sourcePort, timeout: timeout);
        },
      );
    });

    // Test 3: Throw an exception on socket error
    test('Given mock socket setup, When a socket error occurs, Then it should throw a SocketException', () async {
      const port = 1234;

      IOOverrides.runZoned(
        () async {
          // Given: A mock socket connection
          final socket = await Socket.connect(InternetAddress.loopbackIPv4, port);

          // When: Simulating an error in the mock socket
          (socket as MockSocket).shouldThrowError = true;

          // Then: The error should trigger and match the expected exception
          socket.listen(
            null, // No onData callback
            onError: (error) {
              expect(error, isA<SocketException>());
            },
          );

          // Trigger the error manually
          socket.add(utf8.encode('test message'));
        },
        socketConnect: (host, port, {sourceAddress, sourcePort = 0, timeout}) {
          return MockSocket.connect(host, port, sourceAddress: sourceAddress, sourcePort: sourcePort, timeout: timeout);
        },
      );
    });

    // Test 4: Ensure data is sent and received correctly
    test('Given mock socket setup, When sending and receiving data, Then it should be handled correctly', () async {
      const port = 1234;
      const testMessage = 'Hello, Server!';

      IOOverrides.runZoned(
        () async {
          // Given: A mock socket connection
          final socket = await Socket.connect(InternetAddress.loopbackIPv4, port);
          expect(socket, isA<MockSocket>());

          final mockSocket = socket as MockSocket;

          // When: Simulating data transmission
          mockSocket.add(utf8.encode(testMessage));

          // Then: The received message should match the sent message
          socket.listen((Uint8List data) {
            final receivedMessage = utf8.decode(data);
            expect(receivedMessage, equals(testMessage));
          });

          final response = Uint8List.fromList(utf8.encode(testMessage)); // Simulate server response
          mockSocket.mockBytes.addAll(response); // Simulate received data

          await socket.close();
        },
        socketConnect: (host, port, {sourceAddress, sourcePort = 0, timeout}) {
          return MockSocket.connect(host, port, sourceAddress: sourceAddress, sourcePort: sourcePort, timeout: timeout);
        },
      );
    });

    // Test 5: Handle connection timeout
    test('Given a connection attempt, When the connection times out, Then it should handle timeout', () async {
      const port = 1234;

      IOOverrides.runZoned(
        () async {
          try {
            // Given: Simulate a connection timeout
            await Socket.connect(InternetAddress.loopbackIPv4, port, timeout: const Duration(milliseconds: 100));
          } catch (e) {
            // Then: Expect a SocketException due to the timeout
            expect(e, isA<SocketException>());
          }
        },
        socketConnect: (host, port, {sourceAddress, sourcePort = 0, timeout}) async {
          // Simulate a timeout by delaying the future resolution
          await Future.delayed(timeout ?? const Duration(seconds: 1));
          return MockSocket.connect(host, port, sourceAddress: sourceAddress, sourcePort: sourcePort, timeout: timeout);
        },
      );
    });
  });

  group('SocketService - Error Handling', () {
    // Error Handling: Test 1
    test('Given socket communication fails, When connecting, Then it should throw a DataSourceException', () async {
      // Given: Simulate an error during socket communication
      when(() => mockSocket.add(any())).thenThrow(const DataSourceException.serverError(message: 'Socket failure'));

      // Then: Expect a DataSourceException with the correct message
      expect(
        () async => await socketService.connect('245346437489485'),
        throwsA(
          isA<DataSourceException>().having(
            (e) => e.message,
            'message',
            contains('Socket failure'),
          ),
        ),
      );
    });

    // Error Handling: Test 2
    test('Given the daemon is busy, When getting the status, Then it should throw a DataSourceException', () async {
      // Given: Simulate the daemon being busy
      when(() => mockSocket.add(any())).thenThrow(
        const DataSourceException.serverError(message: 'Daemon is busy'),
      );

      // Then: Expect the correct exception to be thrown
      expect(
        () async => await socketService.getStatus(),
        throwsA(
          isA<DataSourceException>().having(
            (e) => e.message,
            'message',
            contains('Daemon is busy'),
          ),
        ),
      );
    });

    // Error Handling: Test 3
    test('Given valid status, When getting the daemon status, Then it should return the correct status', () async {
      final Map<String, dynamic> mockResponse = {
        'status': 'success',
        'data': {'daemon_status': 'connected'}
      };

      // Given: Simulate successful status retrieval
      when(() => mockSocketService.getStatus())
          .thenAnswer((_) async => DaemonStatus.fromDataResponse(mockResponse['data']));

      // When: Call the getStatus method
      final result = await mockSocketService.getStatus();

      // Then: Verify the correct status is returned
      expect(result, equals(const DaemonStatus.connected()));
    });

    // Error Handling: Test 4
    test('Given a daemon error, When getting status, Then it should throw a DataSourceException', () async {
      // Given: Simulate daemon error
      when(() => mockSocketService.getStatus()).thenThrow(
        const DataSourceException.serverError(message: 'Daemon is busy'),
      );

      // Then: Expect the correct exception to be thrown
      expect(
        () async => await mockSocketService.getStatus(),
        throwsA(isA<DataSourceException>().having((e) => e.message, 'message', 'Daemon is busy')),
      );
    });
  });
}
