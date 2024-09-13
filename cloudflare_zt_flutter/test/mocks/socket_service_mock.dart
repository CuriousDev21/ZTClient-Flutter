import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:mocktail/mocktail.dart';

class MockSocket extends Mock implements Socket {
  List<int> mockBytes = [];
  bool shouldThrowError = false; // Flag to simulate errors

  // Static method to simulate Socket.connect(), returning Future<Socket>
  static Future<Socket> connect(
    dynamic host,
    int port, {
    dynamic sourceAddress,
    int sourcePort = 0, // Ensure sourcePort is not nullable
    Duration? timeout,
  }) {
    final completer = Completer<Socket>();
    final socket = MockSocket();
    completer.complete(socket); // Complete with a MockSocket instance
    return completer.future; // Return Future<Socket>
  }

  @override
  void add(List<int> data) {
    mockBytes.addAll(data); // Simulate adding data to the socket
  }

  @override
  StreamSubscription<Uint8List> listen(
    void Function(Uint8List event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    // If we want to simulate an error
    if (shouldThrowError) {
      // Trigger onError callback instead of throwing an exception directly
      onError?.call(const SocketException('Connection error'));
    } else {
      final out = Uint8List.fromList(mockBytes); // Simulate data reception
      onData?.call(out); // Simulate data reception
    }

    return Stream<Uint8List>.fromIterable([Uint8List.fromList(mockBytes)]).listen(null);
  }

  @override
  Future<void> flush() async {
    // Simulate asynchronous flushing behavior
  }

  @override
  Future<void> close() async {
    // Simulate closing the socket
  }

  @override
  Future get done => Future.value(); // Simulate completion of socket
}
