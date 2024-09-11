import 'package:cloudflare_zt_flutter/data/repositories/daemon_connection_repository.dart';
import 'package:cloudflare_zt_flutter/data/repositories/token_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract class RepositoryProvider {
  static Provider<TokenRepository> get token => tokenRepositoryProvider;
  static Provider<ConnectionRepository> get vpn => daemonRepositoryProvider;
}
