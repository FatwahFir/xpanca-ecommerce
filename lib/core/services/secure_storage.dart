import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/auth/data/models/user_model.dart';

abstract class SecureStorage {
  Future<void> writeToken(String token);
  Future<String?> readToken();

  Future<void> writeUser(UserModel user);
  Future<UserModel?> readUser();

  Future<void> clear();
}

class SecureStorageImpl implements SecureStorage {
  final _s = const FlutterSecureStorage();
  static const _kToken = 'auth_token';
  static const _kUser = 'auth_user';

  @override
  Future<void> writeToken(String token) => _s.write(key: _kToken, value: token);

  @override
  Future<String?> readToken() => _s.read(key: _kToken);

  @override
  Future<void> writeUser(UserModel user) =>
      _s.write(key: _kUser, value: jsonEncode(user.toJson()));

  @override
  Future<UserModel?> readUser() async {
    final raw = await _s.read(key: _kUser);
    if (raw == null) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return UserModel.fromJson(map);
  }

  @override
  Future<void> clear() async {
    await _s.delete(key: _kToken);
    await _s.delete(key: _kUser);
  }
}
