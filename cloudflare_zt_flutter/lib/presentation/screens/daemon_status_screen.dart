import 'package:cloudflare_zt_flutter/core/utils/constants/dimensions.dart';
import 'package:cloudflare_zt_flutter/core/utils/theme/app_style.dart';
import 'package:cloudflare_zt_flutter/core/widgets/responsive_container.dart';
import 'package:cloudflare_zt_flutter/presentation/providers/vpn_action_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen for checking the status of the VPN daemon.
/// The screen displays the current status of the VPN daemon and allows the user to connect or disconnect from the VPN.
///
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
        title: Text(
          'VPN Status Check',
          style: AppTextStyles.headlineMedium,
        ),
        backgroundColor: AppColors.backgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: ResponsiveCenter(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            vpnActionState.when(
              data: (statusState) => Column(
                children: [
                  Text(
                    statusState.statusMessage,
                    style: AppTextStyles.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Sizes.p12),
                  if (statusState.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
                      child: Text(
                        'Error: ${statusState.errorMessage}',
                        style: AppTextStyles.errorText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
              loading: () => Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: Sizes.p16),
                  Text(
                    'Checking VPN status...',
                    style: AppTextStyles.bodyText, // Use bodyText for general information
                  ),
                ],
              ),
              error: (err, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: Sizes.p32),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: vpnActionState.maybeWhen(
                    data: (statusState) => () => statusState.isConnected
                        ? ref.read(vpnActionNotifierProvider.notifier).disconnect()
                        : ref.read(vpnActionNotifierProvider.notifier).connect(),
                    orElse: () => null,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizes.p16,
                      horizontal: Sizes.p32,
                    ),
                    backgroundColor: vpnActionState.maybeWhen(
                      data: (statusState) => statusState.isConnected ? AppColors.errorColor : AppColors.primaryColor,
                      orElse: () => AppColors.primaryColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Sizes.p8),
                    ),
                  ),
                  child: Text(
                    vpnActionState.when(
                      data: (statusState) => statusState.isConnected ? 'Disconnect VPN' : 'Connect VPN',
                      loading: () => 'Loading...',
                      error: (err, _) => 'Failed, fetching status...',
                    ),
                    style: AppTextStyles.buttonText,
                  ),
                ),
                // Display detailed error message below the button if there's an error
                vpnActionState.maybeWhen(
                  error: (err, _) => Padding(
                    padding: const EdgeInsets.only(top: Sizes.p8),
                    child: Text(
                      err.toString(), // Display the actual error message
                      style: AppTextStyles.errorText.copyWith(fontSize: 14), // Small font for detailed errors
                      textAlign: TextAlign.center,
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
