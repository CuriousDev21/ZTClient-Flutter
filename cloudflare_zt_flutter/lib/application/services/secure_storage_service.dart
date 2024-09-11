import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService.instance;
});

final class SecureStorageService {
  SecureStorageService._();

  static final _instance = SecureStorageService._();
  static SecureStorageService get instance => _instance;

  final _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));

  Future<void> write({required String key, required String? value}) async {
    return _storage.write(key: key, value: value);
  }

  Future<String?> read({required String key}) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      return null;
    }
  }

  Future<void> delete({required String key}) async {
    return _storage.delete(key: key);
  }
}

abstract class SecureStorageKeys {
  static const String authToken = 'auth_token';
  static const String tokenTimestamp = 'token_timestamp';
}
