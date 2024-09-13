import 'dart:async';

import 'package:cloudflare_zt_flutter/application/providers/repository.abs.dart';
import 'package:cloudflare_zt_flutter/application/providers/service.abs.dart';
import 'package:cloudflare_zt_flutter/data/repositories/token_repository.dart';
import 'package:cloudflare_zt_flutter/domain/errors/data_source_exception.dart';
import 'package:cloudflare_zt_flutter/domain/models/auth/auth_token.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vpn_action_notifier.freezed.dart';
part 'vpn_action_notifier.g.dart';

/// Notifier that handles the VPN actions
///  - Connect to VPN Daemon
/// - Disconnect from VPN Daemon
/// - Fetch the current status of the VPN Daemon
/// - Listen to the status of the VPN Daemon
/// - Notify the UI about the status of the VPN Daemon
@riverpod
class VpnActionNotifier extends _$VpnActionNotifier {
  StreamSubscription? _sub;

  @override
  Future<DaemonStatusState> build() async {
    _listenToStream();
    ref.onDispose(() => _sub?.cancel());

    return const DaemonStatusState(
      statusMessage: 'Disconnected',
      isConnected: false,
    );
  }

  void _listenToStream() => _sub = Stream.periodic(const Duration(seconds: 5)).listen((_) async {
        final newState = await AsyncValue.guard(() => _fetchStatus());
        if (_sub?.isPaused == false) state = newState;
      });

  Future<DaemonStatusState> _fetchStatus() async {
    // Ensure the timer is cleaned up when the provider is disposed

    // Perform the actual status check
    final vpnRepo = ref.read(RepositoryProvider.vpn);
    try {
      final status = await vpnRepo.getStatus();

      // Handle the successful "disconnected" with an error message case
      return status.map(
        connected: (_) => const DaemonStatusState(
          statusMessage: 'Connected!',
          isConnected: true,
        ),
        disconnected: (_) => const DaemonStatusState(
          statusMessage: 'Disconnected',
          isConnected: false,
        ),
        error: (error) => DaemonStatusState(
          statusMessage: 'Disconnected', // Even if the status is "error", the VPN is still disconnected
          errorMessage: error.message,
          isConnected: false,
        ),
      );
    } on DataSourceException catch (e) {
      // Return a DaemonStatusState with the error message
      return DaemonStatusState(
        statusMessage: 'Disconnected',
        errorMessage: e.message ?? 'Failed to check VPN status',
        isConnected: false,
      );
    } catch (e) {
      // Return a DaemonStatusState with a generic error message
      return const DaemonStatusState(
        statusMessage: 'Disconnected',
        errorMessage: 'Failed to check VPN status',
        isConnected: false,
      );
    }
  }

  // Connect to VPN Daemon
  Future<void> connect() async {
    _sub?.cancel();
    state = const AsyncLoading(); // Set loading state while performing the action

    try {
      final tokenRepo = ref.read(RepositoryProvider.token);
      final vpnRepo = ref.read(RepositoryProvider.vpn);

      final authToken = await tokenRepo.getAuthToken() ?? await _fetchAndCacheAuthToken(tokenRepo);

      await vpnRepo.connect(authToken.token);

      // Set the connected state after successful connection
      state = const AsyncData(
        DaemonStatusState(
          statusMessage: 'Connected!',
          isConnected: true,
        ),
      );
    } on DataSourceException catch (e, s) {
      // Set the error state with the error message
      state = AsyncValue.error(e.message ?? 'Failed to connect to VPN', s);
    } catch (e, s) {
      state = AsyncValue.error('Failed to connect to VPN', s);
    }

    _listenToStream();
  }

  // Disconnect from VPN Daemon
  Future<void> disconnect() async {
    _sub?.cancel();
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
    } on DataSourceException catch (e, s) {
      // Set the error state with the error message
      state = AsyncValue.error(e.message ?? 'Failed to disconnect from VPN', s);
    } catch (e, s) {
      state = AsyncValue.error('Failed to disconnect from the VPN', s);
    }
    _listenToStream();
  }

  // Helper method to fetch and cache the token
  Future<AuthToken> _fetchAndCacheAuthToken(TokenRepository tokenRepo) async {
    final authService = ref.read(ServiceProvider.auth);
    final newToken = await authService.getRemoteAuthToken();
    await tokenRepo.cacheAuthToken(newToken);
    return newToken;
  }
}

@freezed
class DaemonStatusState with _$DaemonStatusState {
  const factory DaemonStatusState({
    required String statusMessage, // The current status (e.g., connected, disconnected)
    String? errorMessage, // Optional error message to display
    required bool isConnected, // Indicates whether the VPN is connected
  }) = _DaemonStatusState;
}
