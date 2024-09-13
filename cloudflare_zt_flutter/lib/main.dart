import 'package:cloudflare_zt_flutter/presentation/screens/daemon_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      // Wrapping the app in ProviderScope for Riverpod
      child: MaterialContext(),
    ),
  );
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
