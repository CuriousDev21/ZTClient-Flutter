import 'package:cloudflare_zt_flutter/application/providers/repository.abs.dart';
import 'package:cloudflare_zt_flutter/application/providers/service.abs.dart';
import 'package:cloudflare_zt_flutter/data/repositories/token_repository.dart';
import 'package:cloudflare_zt_flutter/domain/errors/data_source_exception.dart';
import 'package:cloudflare_zt_flutter/domain/models/auth/auth_token.dart';
import 'package:cloudflare_zt_flutter/domain/models/daemon/daemon_status.dart';
import 'package:cloudflare_zt_flutter/presentation/providers/status_check_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vpn_action_notifier.g.dart';

@riverpod
class VpnActionNotifier extends _$VpnActionNotifier {
  @override
  FutureOr<DaemonStatusState> build() async {
    // Start with disconnected state
    return const DaemonStatusState(
      statusMessage: 'Disconnected',
      isConnected: false,
    );
  }

  // Connect to VPN Daemon
  Future<void> connect() async {
    state = const AsyncLoading(); // Set loading state while performing the action

    try {
      final tokenRepo = ref.read(RepositoryProvider.token);
      final vpnRepo = ref.read(RepositoryProvider.vpn);

      final authToken = await tokenRepo.getAuthToken() ?? await _fetchAndCacheAuthToken(tokenRepo);

      await vpnRepo.connect(authToken.token);

      // Set the connected state after successful connection
      state = const AsyncData(
        DaemonStatusState(
          statusMessage: 'Connected',
          isConnected: true,
        ),
      );
      // Invalidate the status check provider to refresh status
      ref.invalidate(statusCheckProvider);
    } on DataSourceException catch (e, s) {
      // Set the error state with the error message
      state = AsyncValue.error(e.message ?? 'Failed to connect to VPN', s);
    } catch (e, s) {
      state = AsyncValue.error('Failed to connect to VPN', s);
    }
  }

  // Disconnect from VPN Daemon
  Future<void> disconnect() async {
    state = const AsyncLoading();

    try {
      final vpnRepo = ref.read(RepositoryProvider.vpn);
      await vpnRepo.disconnect();

      // Set the disconnected state after successful disconnection
      state = const AsyncData(
        DaemonStatusState(
          statusMessage: 'Disconnected',
          isConnected: false,
        ),
      );
      ref.invalidate(statusCheckProvider);
    } on DataSourceException catch (e, s) {
      // Set the error state with the error message
      state = AsyncValue.error(e.message ?? 'Failed to disconnect from VPN', s);
    } catch (e, s) {
      state = AsyncValue.error('Failed to discconnect from the VPN', s);
    }
  }

  // Helper method to fetch and cache the token
  Future<AuthToken> _fetchAndCacheAuthToken(TokenRepository tokenRepo) async {
    final authService = ref.read(ServiceProvider.auth);
    final newToken = await authService.getAuthToken();
    await tokenRepo.cacheAuthToken(newToken);
    return newToken;
  }
}