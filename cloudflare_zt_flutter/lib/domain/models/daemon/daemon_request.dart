import 'dart:convert';

/// A class representing a request to the daemon
///   - [connect] request to connect to the daemon
///   - [disconnect] request to disconnect from the daemon
///  - [getStatus] request to get the status of the daemon
///   - [request] the request payload
class DaemonRequest {
  final Map<String, dynamic> request;

  DaemonRequest._(this.request);

  /// Create a connect request with the auth token
  factory DaemonRequest.connect(int authToken) {
    return DaemonRequest._({
      'request': {'connect': authToken}
    });
  }

  /// Create a disconnect request
  factory DaemonRequest.disconnect() {
    return DaemonRequest._({
      'request': 'disconnect',
    });
  }

  /// Create a get status request
  factory DaemonRequest.getStatus() {
    return DaemonRequest._({
      'request': 'get_status',
    });
  }

  String toJsonString() {
    return jsonEncode(request);
  }
}
