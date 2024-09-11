import 'package:cloudflare_zt_flutter/presentation/providers/vpn_action_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DaemonStatusScreen extends ConsumerStatefulWidget {
  const DaemonStatusScreen({super.key});

  @override
  ConsumerState createState() => _DaemonStatusState();
}

class _DaemonStatusState extends ConsumerState<DaemonStatusScreen> {
  @override
  Widget build(BuildContext context) {
    final vpnActionState = ref.watch(vpnActionNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('VPN Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display VPN Status with polling from statusCheckProvider
            vpnActionState.when(
              data: (statusState) => Column(
                children: [
                  Text(statusState.statusMessage),
                  // Check if combinedErrorState is not null and display error message
                  if (statusState.errorMessage != null)
                    Text(
                      'Error: ${statusState.errorMessage.toString()})',
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: vpnActionState.maybeWhen(
                data: (statusState) => () => statusState.isConnected
                    ? ref.read(vpnActionNotifierProvider.notifier).disconnect()
                    : ref.read(vpnActionNotifierProvider.notifier).connect(),
                orElse: () => null,
              ),
              child: Text(
                vpnActionState.when(
                  data: (statusState) => statusState.isConnected ? 'Disconnect VPN' : 'Connect VPN',
                  loading: () => 'Loading',
                  error: (_, __) => 'Error',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
