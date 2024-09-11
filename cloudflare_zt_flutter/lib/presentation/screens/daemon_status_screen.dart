import 'dart:async';

import 'package:cloudflare_zt_flutter/domain/models/daemon/daemon_status.dart';
import 'package:cloudflare_zt_flutter/presentation/providers/daemon_error_provider.dart';
import 'package:cloudflare_zt_flutter/presentation/providers/status_check_notifier.dart';
import 'package:cloudflare_zt_flutter/presentation/providers/vpn_action_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DaemonStatusScreen extends ConsumerStatefulWidget {
  const DaemonStatusScreen({super.key});

  @override
  ConsumerState createState() => _DaemonStatusState();
}

class _DaemonStatusState extends ConsumerState<DaemonStatusScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Watch the status check provider for continuous status tracking
    final statusCheck = ref.watch(statusCheckProvider);

    // Watch the VPN action provider (connect/disconnect actions)
    final vpnActionState = ref.watch(vpnActionNotifierProvider);

    // Watch for combined errors from both providers via combinedVpnErrorProvider
    final combinedErrorState = ref.watch(combinedVpnErrorNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('VPN Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display VPN Status with polling from statusCheckProvider
            statusCheck.when(
              data: (statusState) => Column(
                children: [
                  Text(statusState.statusMessage),
                  // Check if combinedErrorState is not null and display error message
                  if (combinedErrorState.hasError)
                    Text(
                      'Error: ${combinedErrorState.error.toString()})',
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),

            // VPN Action Button (connect/disconnect) based on vpnActionProvider state
            vpnActionState.when(
              data: (statusState) => ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () => _tap(() => statusState.isConnected
                        ? ref.read(vpnActionNotifierProvider.notifier).disconnect()
                        : ref.read(vpnActionNotifierProvider.notifier).connect()),
                child: Text(statusState.isConnected ? 'Disconnect VPN' : 'Connect VPN'),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => ElevatedButton(
                onPressed: _isLoading ? null : () => _tap(() => ref.read(vpnActionNotifierProvider.notifier).connect()),
                child: const Text('Connect VPN'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FutureOr<void> _tap(FutureOr<void> Function() action) async {
    setState(() => _isLoading = true);
    try {
      await action();
    } catch (e) {
      rethrow;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
