import 'dart:ui';

import 'package:cloudflare_zt_flutter/presentation/screens/daemon_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/utils/logger/app_logger.dart';

void main() {
  // Initialize the logging system
  logger.runLogging(() async {
    // Flutter's error logging mechanism to use our logger
    FlutterError.onError = logger.logFlutterError;

    // PlatformDispatcher's error handling (for non-Flutter errors)
    PlatformDispatcher.instance.onError = logger.logPlatformDispatcherError;

    // Any other necessary initializations here

    runApp(
      const ProviderScope(
        // Wrapping the app in ProviderScope for Riverpod
        child: MaterialContext(),
      ),
    );
  });
}

class MaterialContext extends StatelessWidget {
  const MaterialContext({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VPN Daemon Status Checker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DaemonStatusScreen(),
    );
  }
}
