import 'package:cloudflare_zt_flutter/application/services/auth_service.dart';
import 'package:cloudflare_zt_flutter/application/services/secure_storage_service.dart';
import 'package:cloudflare_zt_flutter/application/services/socket_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract class ServiceProvider {
  static Provider<SecureStorageService> get secureStorage => secureStorageServiceProvider;
  static Provider<SocketService> get socket => socketServiceProvider;
  static Provider<AuthService> get auth => authServiceProvider;
}
