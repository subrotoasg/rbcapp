import 'package:rbc_flutter_professional/core/config/app_config.dart';

class AppUser {
  AppUser({
    required this.email,
    required this.name,
    required this.photo,
    required this.token,
    required this.role,
    DateTime? loginAt,
    DateTime? expiresAt,
  })  : loginAt = loginAt ?? DateTime.now(),
        expiresAt = expiresAt ?? DateTime.now().add(AppConfig.sessionDuration);

  final String email;
  final String name;
  final String photo;
  final String token;
  final String role;
  final DateTime loginAt;
  final DateTime expiresAt;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    final loginAt = DateTime.tryParse('${json['loginAt'] ?? ''}') ?? now;
    final expiresAt = DateTime.tryParse('${json['expiresAt'] ?? ''}') ??
        loginAt.add(AppConfig.sessionDuration);
    return AppUser(
      email: '${json['email'] ?? ''}',
      name: '${json['name'] ?? ''}',
      photo: '${json['photo'] ?? json['avatar'] ?? ''}',
      token: '${json['token'] ?? json['accessToken'] ?? ''}',
      role: '${json['role'] ?? 'user'}',
      loginAt: loginAt,
      expiresAt: expiresAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'photo': photo,
        'token': token,
        'role': role,
        'loginAt': loginAt.toIso8601String(),
        'expiresAt': expiresAt.toIso8601String(),
      };

  bool get isPrivileged => ['admin', 'rbc', 'moderator'].contains(role);
  bool get isSessionValid => DateTime.now().isBefore(expiresAt);
}
