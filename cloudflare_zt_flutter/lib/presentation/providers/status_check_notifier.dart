// path: lib/presentation/providers/polling_provider.dart
import 'package:cloudflare_zt_flutter/application/providers/repository.abs.dart';
import 'package:cloudflare_zt_flutter/domain/errors/data_source_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';

part 'status_check_notifier.g.dart';

part 'status_check_notifier.freezed.dart';

@riverpod
Future<DaemonStatusState> statusCheck(StatusCheckRef ref) async {
  // Set up the polling mechanism to check the VPN status every 5 seconds
  final timer = Timer.periodic(const Duration(seconds: 5), (_) {
    ref.invalidateSelf(); // Re-trigger the status check
  });

  // Ensure the timer is cleaned up when the provider is disposed
  ref.onDispose(() => timer.cancel());

  // Perform the actual status check
  final vpnRepo = ref.read(RepositoryProvider.vpn);
  try {
    final status = await vpnRepo.getStatus();

    // Handle the successful "disconnected" with an error message case
    return status.map(
      connected: (_) => const DaemonStatusState(
        statusMessage: 'Connected',
        isConnected: true,
      ),
      disconnected: (_) => const DaemonStatusState(
        statusMessage: 'Disconnected',
        isConnected: false,
      ),
      error: (error) => DaemonStatusState(
        statusMessage: 'Disconnected', // Consider disconnected with an error
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
    return DaemonStatusState(
      statusMessage: 'Disconnected',
      errorMessage: 'Failed to check VPN status',
      isConnected: false,
    );
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
