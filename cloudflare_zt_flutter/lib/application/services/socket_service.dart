import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloudflare_zt_flutter/core/utils/logger/app_logger.dart';
import 'package:cloudflare_zt_flutter/domain/errors/data_source_exception.dart';
import 'package:cloudflare_zt_flutter/domain/models/daemon/daemon_request.dart';
import 'package:cloudflare_zt_flutter/domain/models/daemon/daemon_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final socketServiceProvider = Provider<SocketService>((ref) {
  return SocketService();
});

class SocketService {
  final String _socketPath = "/tmp/daemon-lite";
  Socket? _socket;
  final List<int> _buffer = [];
  StreamSubscription<Uint8List>? _socketSubscription;
  Completer<Map<String, dynamic>>? _responseCompleter;

  /// Ensure the connection to the daemon is established.
  Future<void> _ensureConnected() async {
    if (_socket != null) return; // Reuse existing connection if available

    try {
      logger.info("Attempting to connect to the daemon.");
      var address = InternetAddress(_socketPath, type: InternetAddressType.unix);
      _socket = await Socket.connect(address, 0);
      logger.info("Successfully connected to the daemon.");
      _listenToSocket(); // Start listening to the socket for responses
    } on SocketException catch (e) {
      logger.error("Failed to connect to the daemon: ${e.message}");
      throw DataSourceException.connection(message: 'Failed to connect to the daemon: ${e.message}');
    }
  }

  /// Start listening to the socket.
  void _listenToSocket() {
    logger.debug("Listening for responses from the daemon.");
    _socketSubscription = _socket?.listen(
      _processData,
      onError: (error) {
        logger.error("Socket communication error: $error");
        throw DataSourceException.serverError(message: 'Socket communication error: $error');
      },
      onDone: () {
        logger.info("Socket connection closed.");
        _closeSocket();
      },
      cancelOnError: true,
    );
  }

  /// Close the socket connection.
  void _closeSocket() {
    logger.info("Closing socket connection.");
    _socketSubscription?.cancel();
    _socket?.destroy();
    _socket = null;
  }

  /// Process incoming data from the socket.
  void _processData(Uint8List data) {
    logger.debug("Processing data from the socket.");
    _buffer.addAll(data);

    // If a response completer is available, try to resolve it
    if (_responseCompleter != null) {
      try {
        var response = _readResponseFromBuffer();
        if (response != null) {
          logger.info("Received response from the daemon: $response");
          _responseCompleter!.complete(response);
        }
      } on DataSourceException catch (e) {
        logger.error("Error while reading response: ${e.message}");
        _responseCompleter!.completeError(e);
      } catch (e) {
        logger.error("Generic error while reading server response: $e");
        _responseCompleter!.completeError(
          DataSourceException.serverError(message: 'Failed to read server response: $e'),
        );
      }
    }
  }

  /// Read response data from the buffer.
  Map<String, dynamic>? _readResponseFromBuffer() {
    if (_buffer.length < 8) return null; // Wait for the 8-byte size header

    // Read the size of the payload
    final sizeBytes = _buffer.sublist(0, 8);
    final size = ByteData.sublistView(Uint8List.fromList(sizeBytes)).getInt64(0, Endian.host);

    if (_buffer.length - 8 < size) return null; // Wait until the full payload arrives

    // Read the actual payload
    final payloadBytes = _buffer.sublist(8, 8 + size);
    _buffer.removeRange(0, 8 + size); // Remove processed bytes from the buffer
    final payload = utf8.decode(payloadBytes);

    // Parse the JSON response
    final response = json.decode(payload) as Map<String, dynamic>;
    logger.debug("Parsed JSON response: $response");

    // Check for errors or special cases in the response
    if (response['status'] == 'error') {
      logger.warning("Daemon responded with error: ${response['message']}");
      throw DataSourceException.fromDaemonResponse(response);
    } else if (response['status'] == 'success' &&
        response['data']['daemon_status'] == 'disconnected' &&
        response['data']['message'] != null) {
      logger.warning("Daemon disconnected with message: ${response['data']['message']}");
      throw DataSourceException.serverError(
        message: response['data']['message'] ?? 'Unknown disconnection issue',
      );
    }

    return response;
  }

  /// Send a request payload to the daemon and wait for the response.
  Future<Map<String, dynamic>> _sendRequest(DaemonRequest request) async {
    logger.info("Sending request to the daemon: ${request.toJsonString()}");
    await _ensureConnected();

    final payloadData = utf8.encode(request.toJsonString());
    final payloadSize = payloadData.length;
    final sizeBytes = Uint8List(8)..buffer.asByteData().setInt64(0, payloadSize, Endian.little);

    _responseCompleter = Completer<Map<String, dynamic>>();

    try {
      _socket!.add(sizeBytes);
      _socket!.add(payloadData);
      await _socket!.flush();
    } catch (e) {
      logger.error("Failed to send request to the daemon: $e");
      throw DataSourceException.serverError(message: 'Failed to send request to the daemon: $e');
    }

    // Wait for the response to be processed
    return _responseCompleter!.future;
  }

  /// Connect to the VPN daemon using the auth token.
  Future<void> connect(String authToken) async {
    logger.info("Attempting to connect to VPN with token: $authToken");
    final connectRequest = DaemonRequest.connect(int.parse(authToken));
    await _sendRequest(connectRequest);
  }

  /// Disconnect from the VPN daemon.
  Future<void> disconnect() async {
    logger.info("Attempting to disconnect from the VPN.");
    final disconnectRequest = DaemonRequest.disconnect();
    await _sendRequest(disconnectRequest);
  }

  /// Get the current status of the VPN daemon.
  Future<DaemonStatus> getStatus() async {
    logger.info("Checking VPN daemon status.");
    final statusRequest = DaemonRequest.getStatus();
    final response = await _sendRequest(statusRequest);
    return DaemonStatus.fromJson(response['data']);
  }

  /// Dispose of the socket connection when done.
  void dispose() {
    logger.info("Disposing of the socket connection.");
    _closeSocket();
  }
}
