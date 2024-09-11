import 'package:freezed_annotation/freezed_annotation.dart';

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
