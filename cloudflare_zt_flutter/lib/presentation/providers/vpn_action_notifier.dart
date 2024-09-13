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

/// Notifier that handles VPN actions such as connecting, disconnecting, and checking the status of the VPN daemon.
///
/// This class periodically polls the VPN daemon for its current status and notifies
/// the UI about the connection status.
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

  /// Connects to the VPN daemon.
  Future<void> connect() async {
    _sub?.cancel();
    state = const AsyncLoading();

    try {
      final tokenRepo = ref.read(RepositoryProvider.token);
      final vpnRepo = ref.read(RepositoryProvider.vpn);
      final authToken = await tokenRepo.getAuthToken() ?? await _fetchAndCacheAuthToken(tokenRepo);

      await vpnRepo.connect(authToken.token);

      state = const AsyncData(
        DaemonStatusState(
          statusMessage: 'Connected!',
          isConnected: true,
        ),
      );
    } on DataSourceException catch (e, s) {
      state = AsyncValue.error(e.message ?? 'Failed to connect to VPN', s);
    }

    _listenToStream();
  }

  /// Disconnects from the VPN daemon.
  Future<void> disconnect() async {
    _sub?.cancel();
    state = const AsyncLoading();

    try {
      final vpnRepo = ref.read(RepositoryProvider.vpn);
      await vpnRepo.disconnect();

      state = const AsyncData(
        DaemonStatusState(
          statusMessage: 'Disconnected',
          isConnected: false,
        ),
      );
    } on DataSourceException catch (e, s) {
      state = AsyncValue.error(e.message ?? 'Failed to disconnect from VPN', s);
    }

    _listenToStream();
  }

  /// Listens to the stream that periodically fetches the status of the VPN daemon.
  void _listenToStream() => _sub = Stream.periodic(const Duration(seconds: 5)).listen((_) async {
        final newState = await AsyncValue.guard(() => _fetchStatus());
        if (_sub?.isPaused == false) state = newState;
      });

  /// Fetches the current status of the VPN daemon.
  Future<DaemonStatusState> _fetchStatus() async {
    final vpnRepo = ref.read(RepositoryProvider.vpn);
    try {
      final status = await vpnRepo.getStatus();

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
          statusMessage: 'Disconnected',
          errorMessage: error.message,
          isConnected: false,
        ),
      );
    } on DataSourceException catch (e) {
      return DaemonStatusState(
        statusMessage: 'Disconnected',
        errorMessage: e.message ?? 'Failed to check VPN status',
        isConnected: false,
      );
    }
  }

  /// Fetches and caches a new authentication token.
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
