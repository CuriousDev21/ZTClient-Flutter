import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloudflare_zt_flutter/core/utils/logger/app_logger.dart';
import 'package:cloudflare_zt_flutter/domain/errors/data_source_exception.dart';
import 'package:cloudflare_zt_flutter/domain/models/daemon/daemon_request.dart';
import 'package:cloudflare_zt_flutter/domain/models/daemon/daemon_response.dart';
import 'package:cloudflare_zt_flutter/domain/models/daemon/daemon_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final socketServiceProvider = Provider<SocketService>((ref) {
  return SocketService();
});

/// Service responsible for handling communication with the VPN daemon.
///
/// This service is used to connect, disconnect, and get the status of the VPN.
/// It communicates with the daemon over a Unix socket.
class SocketService {
  /// The path of the Unix socket used to communicate with the VPN daemon.
  final String _socketPath;

  /// The socket instance used for communication.
  Socket? _socket;

  /// Buffer to hold incoming data from the socket.
  final List<int> _buffer = [];

  /// Stream subscription to listen to data from the socket.
  StreamSubscription<Uint8List>? _socketSubscription;

  /// Completer used to wait for and handle responses from the daemon.
  Completer<DaemonResponse>? _responseCompleter;

  /// A function that establishes a connection to the daemon via the Unix socket.
  final Future<Socket> Function(InternetAddress address, int port) _connect;

  /// Constructor for [SocketService].
  ///
  /// Optionally, a custom [socketPath] or [connect] method can be provided. If
  /// not, defaults to `/tmp/daemon-lite` and [Socket.connect].
  SocketService(
      {String socketPath = "/tmp/daemon-lite", Future<Socket> Function(InternetAddress, int)? connect, Socket? socket})
      : _socketPath = socketPath,
        _connect = connect ?? Socket.connect {
    _socket = socket;
  }

  /// Ensures that the connection to the daemon is established.
  ///
  /// If the connection is already active, it is reused. Otherwise, the method
  /// attempts to open a new connection to the daemon.
  ///
  /// Throws [DataSourceException] if the connection fails.
  Future<void> _ensureConnected() async {
    if (_socket != null) return; // Reuse existing connection if available

    try {
      logger.info("Attempting to connect to the daemon.");
      var address = InternetAddress(_socketPath, type: InternetAddressType.unix);
      _socket = await _connect(address, 0);
      logger.info("Successfully connected to the daemon.");
      _listenToSocket(); // Start listening to the socket for responses
    } on SocketException catch (e) {
      logger.error("Failed to connect to the daemon: ${e.message}");
      throw DataSourceException.connection(message: 'Failed to connect to the daemon: ${e.message}');
    } catch (e) {
      logger.error("Generic error while connecting to the daemon: $e");
      throw DataSourceException.serverError(message: 'Failed to connect to the daemon: $e');
    }
  }

  /// Starts listening to the Unix socket for responses from the daemon.
  ///
  /// The data received from the socket is processed in [_processData].
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

  /// Closes the connection to the daemon and cleans up resources.
  void _closeSocket() {
    logger.info("Closing socket connection.");
    _socketSubscription?.cancel();
    _socket?.destroy();
    _socket = null;
  }

  /// Processes incoming data from the daemon and completes the response.
  ///
  /// The data is added to a buffer and parsed using [_readResponseFromBuffer].
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

  /// Reads the response from the daemon from the buffered data.
  ///
  /// Returns a [DaemonResponse] object or throws a [DataSourceException] if an
  /// error occurs.
  DaemonResponse? _readResponseFromBuffer() {
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
    final responseJson = json.decode(payload) as Map<String, dynamic>;
    final response = DaemonResponse.fromJson(responseJson);
    logger.debug("Parsed DaemonResponse: $response");

    // Handle error responses from the daemon
    if (response.status == DaemonResponseStatus.error) {
      logger.warning("Daemon responded with error: ${response.message}");
      throw DataSourceException.fromDaemonResponse(response);
    }

    return response;
  }

  /// Sends a request to the daemon and waits for a response.
  ///
  /// Takes a [DaemonRequest] object as input and sends it to the daemon over the
  /// Unix socket. Returns the parsed [DaemonResponse].
  Future<DaemonResponse> _sendRequest(DaemonRequest request) async {
    logger.info("Sending request to the daemon: ${request.toJsonString()}");
    await _ensureConnected();

    final payloadData = utf8.encode(request.toJsonString());
    final payloadSize = payloadData.length;
    final sizeBytes = Uint8List(8)..buffer.asByteData().setInt64(0, payloadSize, Endian.host);

    _responseCompleter = Completer<DaemonResponse>();

    try {
      _socket!.add(sizeBytes);
      _socket!.add(payloadData);
      await _socket!.flush();
    } catch (e) {
      logger.error("Failed to send request to the daemon: $e");
      throw DataSourceException.serverError(message: 'Failed to send request to the daemon: $e');
    }

    return _responseCompleter!.future;
  }

  /// Connects to the VPN daemon using the provided auth token.
  ///
  /// [authToken] is the authentication token used to initiate the connection.
  Future<void> connect(String authToken) async {
    logger.info("Attempting to connect to VPN with token: $authToken");
    final connectRequest = DaemonRequest.connect(int.parse(authToken));
    await _sendRequest(connectRequest);
  }

  /// Disconnects from the VPN daemon.
  Future<void> disconnect() async {
    logger.info("Attempting to disconnect from the VPN.");
    final disconnectRequest = DaemonRequest.disconnect();
    await _sendRequest(disconnectRequest);
  }

  /// Fetches the current status of the VPN daemon.
  ///
  /// Returns a [DaemonStatus] object representing the current state of the VPN.
  Future<DaemonStatus> getStatus() async {
    logger.info("Checking VPN daemon status.");
    final statusRequest = DaemonRequest.getStatus();
    final response = await _sendRequest(statusRequest);
    return DaemonStatus.fromDataResponse(response.data!.toJson());
  }

  /// Disposes of the socket connection and cleans up resources.
  void dispose() {
    logger.info("Disposing of the socket connection.");
    _closeSocket();
  }
}
