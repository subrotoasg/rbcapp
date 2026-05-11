import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rbc_flutter_professional/core/config/app_config.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/core/services/notification_service.dart';
import 'package:rbc_flutter_professional/core/services/token_storage.dart';
import 'package:rbc_flutter_professional/features/auth/user_model.dart';

class AuthController extends ChangeNotifier {
  final _storage = TokenStorage();
  final _api = ApiClient.instance;

  AppUser? user;
  bool isBootstrapping = true;
  bool isBusy = false;
  String? error;

  bool get isAuthenticated => user != null && user!.isSessionValid;

  Future<void> bootstrap() async {
    isBootstrapping = true;
    notifyListeners();
    user = await _storage.readUser();
    isBootstrapping = false;
    notifyListeners();

    final savedUser = user;
    if (savedUser != null) {
      NotificationService.instance.registerDevice(savedUser);
    }
  }

  Future<bool> loginWithGoogle() async {
    isBusy = true;
    error = null;
    notifyListeners();
    try {
      final google = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: AppConfig.googleServerClientId,
      );
      final account = await google.signIn();
      if (account == null) {
        error = 'লগইন বাতিল করা হয়েছে';
        return false;
      }

      await account.authentication;

      final response = await _api.post(
        '/api/auth/create',
        data: {
          'email': account.email,
          'name': account.displayName ?? account.email.split('@').first,
          'photo': account.photoUrl ?? '',
          'role': 'user',
          'type': 'app',
        },
      );

      final token = '${response.data}';
      final decoded = JwtDecoder.decode(token);
      final signedUser = AppUser(
        email: '${decoded['email'] ?? account.email}',
        name: '${decoded['name'] ?? account.displayName ?? ''}',
        photo: account.photoUrl ?? '${decoded['photo'] ?? ''}',
        token: token,
        role: '${decoded['role'] ?? 'user'}',
      );

      user = signedUser;
      await _storage.saveUser(signedUser);
      await NotificationService.instance.registerDevice(signedUser);
      return true;
    } catch (e) {
      error = _friendlyError(e);
      return false;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final google = GoogleSignIn();
    try {
      await google.signOut();
    } catch (_) {}
    await _storage.clear();
    user = null;
    notifyListeners();
  }

  String _friendlyError(Object error) {
    final raw = error.toString();
    if (raw.contains('sign_in_failed') || raw.contains('ApiException: 10')) {
      return 'Google Sign-In কনফিগারেশন মিলছে না। package name, SHA-1/SHA-256 এবং google-services.json যাচাই করুন।';
    }
    if (raw.contains('SocketException') || raw.contains('connection')) {
      return 'ইন্টারনেট সংযোগ পাওয়া যাচ্ছে না। আবার চেষ্টা করুন।';
    }
    return 'লগইন করা যায়নি। আবার চেষ্টা করুন।';
  }
}
