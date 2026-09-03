import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../shared/models/user_model.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  static const String _keyToken = 'sahyan_auth_token';
  static const String _keyUser = 'sahyan_user_data';

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: _keyUser, value: userJson);
  }

  Future<UserModel?> getUser() async {
    final userJson = await _storage.read(key: _keyUser);
    if (userJson == null || userJson.isEmpty) return null;
    try {
      final Map<String, dynamic> map = jsonDecode(userJson);
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: _keyUser);
  }

  Future<void> clearSession() async {
    await deleteToken();
    await deleteUser();
  }
}
