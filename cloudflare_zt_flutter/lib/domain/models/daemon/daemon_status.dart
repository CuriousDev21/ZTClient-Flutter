// path: lib/domain/daemon/daemon_status.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'daemon_status.freezed.dart';

enum DaemonConnectionStatus { connected, disconnected, error }

@freezed
class DaemonStatus with _$DaemonStatus {
  const factory DaemonStatus.connected() = _Connected;
  const factory DaemonStatus.disconnected() = _Disconnected;
  const factory DaemonStatus.error(String message) = _Error;

  factory DaemonStatus.fromDataResponse(Map<String, dynamic> json) {
    switch (json['daemon_status']) {
      case 'connected':
        return const DaemonStatus.connected();
      case 'disconnected':
        return const DaemonStatus.disconnected();
      default:
        return DaemonStatus.error(json['message'] ?? 'Unknown error');
    }
  }
}
