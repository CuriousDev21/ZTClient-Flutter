import 'package:cloudflare_zt_flutter/application/providers/service.abs.dart';
import 'package:cloudflare_zt_flutter/application/services/socket_service.dart';
import 'package:cloudflare_zt_flutter/domain/models/daemon/daemon_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final daemonRepositoryProvider = Provider<ConnectionRepository>((ref) {
  final socketService = ref.read(ServiceProvider.socket);
  return DaemonConnectionRepository(socketService);
});

/// An abstract class that defines the methods for interacting with the VPN daemon.
///
/// This repository is responsible for managing the connection and disconnection
/// with the VPN daemon and fetching the current status of the VPN.
abstract class ConnectionRepository {
  /// Connects to the VPN daemon using the provided authentication token.
  Future<void> connect(String authToken);

  /// Disconnects from the VPN daemon.
  Future<void> disconnect();

  /// Fetches the current status of the VPN daemon.
  Future<DaemonStatus> getStatus();
}

/// A concrete implementation of [ConnectionRepository] that interacts with the
/// VPN daemon using a [SocketService].
///
/// This repository manages the VPN connection, disconnection, and status check.
class DaemonConnectionRepository implements ConnectionRepository {
  final SocketService _socketService;

  /// Creates a new instance of [DaemonConnectionRepository] using the provided
  /// [SocketService] for socket communication.
  DaemonConnectionRepository(this._socketService);

  /// Connects to the VPN daemon using the provided authentication token.
  @override
  Future<void> connect(String authToken) async {
    await _socketService.connect(authToken);
  }

  /// Disconnects from the VPN daemon.
  @override
  Future<void> disconnect() async {
    await _socketService.disconnect();
  }

  /// Fetches the current status of the VPN daemon.
  @override
  Future<DaemonStatus> getStatus() async {
    return await _socketService.getStatus();
  }
}
