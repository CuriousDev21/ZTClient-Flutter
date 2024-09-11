import 'package:cloudflare_zt_flutter/application/providers/service.abs.dart';
import 'package:cloudflare_zt_flutter/application/services/socket_service.dart';
import 'package:cloudflare_zt_flutter/domain/models/daemon/daemon_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final daemonRepositoryProvider = Provider<ConnectionRepository>((ref) {
  final socketService = ref.read(ServiceProvider.socket);
  return DaemonConnectionRepository(socketService);
});

abstract class ConnectionRepository {
  Future<void> connect(String authToken);
  Future<void> disconnect();
  Future<DaemonStatus> getStatus();
}

class DaemonConnectionRepository implements ConnectionRepository {
  final SocketService _socketService;

  DaemonConnectionRepository(this._socketService);

  @override
  Future<void> connect(String authToken) async {
    await _socketService.connect(authToken);
  }

  @override
  Future<void> disconnect() async {
    await _socketService.disconnect();
  }

  @override
  Future<DaemonStatus> getStatus() async {
    return await _socketService.getStatus();
  }
}
