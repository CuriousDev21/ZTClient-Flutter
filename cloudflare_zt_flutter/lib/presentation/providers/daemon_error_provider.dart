import 'package:cloudflare_zt_flutter/presentation/providers/status_check_notifier.dart';
import 'package:cloudflare_zt_flutter/presentation/providers/vpn_action_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daemon_error_provider.g.dart';
part 'daemon_error_provider.freezed.dart';

enum ErrorSource {
  vpnAction,
  statusCheck,
}

@freezed
class VpnErrorState with _$VpnErrorState {
  const factory VpnErrorState({
    required String message,
    ErrorSource? source, // Optional: source of the error (e.g., 'VPN Action' or 'Status Check')
  }) = _VpnErrorState;
}
/*
@riverpod
VpnErrorState? combinedVpnErrorProvider(CombinedVpnErrorProviderRef ref) {
  // Watch the state of both providers
  final vpnActionState = ref.watch(vpnActionNotifierProvider);
  final statusCheckState = ref.watch(statusCheckProvider);

  // Check for errors in statusCheckProvider
  if (statusCheckState.error != null) {
    return VpnErrorState(
      message: statusCheckState.error.toString(),
      source: ErrorSource.statusCheck,
    );
  }

  // Check for errors in vpnActionNotifierProvider
  if (vpnActionState.error != null) {
    return VpnErrorState(
      message: vpnActionState.error.toString(),
      source: ErrorSource.vpnAction,
    );
  }

  // No errors, return null
  return null;
}
*/

@riverpod
class CombinedVpnErrorNotifier extends _$CombinedVpnErrorNotifier {
  @override
  FutureOr<void> build() async {
    // Initialize state to null or AsyncData to indicate no errors
    state = const AsyncData(null);

    // Watch for errors from both providers and combine them
    ref.listen<AsyncValue<DaemonStatusState>>(statusCheckProvider, (previous, next) {
      if (next.value != null) {
        state = AsyncValue.error(
            VpnErrorState(
              message: next.value!.errorMessage.toString(),
              source: ErrorSource.statusCheck,
            ),
            next.stackTrace ?? StackTrace.current);
      }
    });

    ref.listen<AsyncValue<DaemonStatusState>>(vpnActionNotifierProvider, (previous, next) {
      if (next.value != null && next.value!.errorMessage != null) {
        state = AsyncValue.error(
            VpnErrorState(
              message: next.value!.errorMessage.toString(),
              source: ErrorSource.vpnAction,
            ),
            next.stackTrace ?? StackTrace.current);
      }
    });
  }

  // Optional: a method to clear errors and reset state
  void clearError() {
    state = const AsyncData(null);
  }
}
