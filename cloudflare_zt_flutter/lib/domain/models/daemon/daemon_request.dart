import 'dart:convert';

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
