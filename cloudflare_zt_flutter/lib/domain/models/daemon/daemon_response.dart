// domain/models/daemon/daemon_response.dart

enum DaemonResponseStatus { success, error }

/// The response model for daemon responses, handling both general responses
/// and nested structures within the `data` field.
///  - [status] is the status of the response.
/// - [data] is the nested structure within the `data` field.
/// - [message] is the message of the response.
///  - [DaemonDataResponse] is the nested structure within the `data` field.
/// - [daemonStatus] is the status of the daemon.
/// - [message] is the message of the response.
///  - [DaemonResponseStatus] is the status of the response.
/// - [success] is the success status.
class DaemonResponse {
  final DaemonResponseStatus status;
  final DaemonDataResponse? data; // Now the data field can have a structured model
  final String? message;

  DaemonResponse({
    required this.status,
    this.data,
    this.message,
  });

  /// Factory constructor to create a [DaemonResponse] from JSON.
  factory DaemonResponse.fromJson(Map<String, dynamic> json) {
    return DaemonResponse(
      status: DaemonResponseStatus.values.firstWhere((e) => e.toString() == 'DaemonResponseStatus.${json['status']}'),
      data: json['data'] != null ? DaemonDataResponse.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  /// Convert the [DaemonResponse] instance back to JSON.
  Map<String, dynamic> toJson() {
    return {
      'status': status.toString().split('.').last,
      'data': data?.toJson(),
      'message': message,
    };
  }
}

/// Model for the nested structure within the `data` field of [DaemonResponse].
/// - [daemonStatus] is the status of the daemon.
/// - [message] is the message of the response.
class DaemonDataResponse {
  final String? daemonStatus;
  final String? message;

  DaemonDataResponse({
    this.daemonStatus,
    this.message,
  });

  /// Factory constructor to create [DaemonData] from JSON.
  factory DaemonDataResponse.fromJson(Map<String, dynamic> json) {
    return DaemonDataResponse(
      daemonStatus: json['daemon_status'],
      message: json['message'],
    );
  }

  /// Convert the [DaemonData] instance back to JSON.
  Map<String, dynamic> toJson() {
    return {
      'daemon_status': daemonStatus,
      'message': message,
    };
  }
}
