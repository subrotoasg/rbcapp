import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rbc_flutter_professional/features/auth/user_model.dart';

class TokenStorage {
  static const _key = 'currentUser';
  static const _storage = FlutterSecureStorage();

  Future<AppUser?> readUser() async {
    final raw = await _storage.read(key: _key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final user = AppUser.fromJson(jsonDecode(raw));
      if (!user.isSessionValid || user.token.isEmpty) {
        await clear();
        return null;
      }
      return user;
    } catch (_) {
      await clear();
      return null;
    }
  }

  Future<void> saveUser(AppUser user) async {
    await _storage.write(key: _key, value: jsonEncode(user.toJson()));
  }

  Future<void> clear() => _storage.delete(key: _key);
}
