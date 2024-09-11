import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_token.freezed.dart';
part 'auth_token.g.dart';

@freezed
class AuthToken with _$AuthToken {
  const factory AuthToken({
    required String token,
    required DateTime timestamp,
  }) = _AuthToken;

  const AuthToken._();

  factory AuthToken.fromJson(Map<String, dynamic> json) => _$AuthTokenFromJson(json);

  bool isExpired() {
    return DateTime.now().difference(timestamp).inMinutes >= 5;
  }
}