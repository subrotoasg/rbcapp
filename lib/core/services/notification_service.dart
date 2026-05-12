import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/features/auth/user_model.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final ApiClient _api = ApiClient.instance;

  String? _lastToken;
  String? _lastEmail;
  bool _busy = false;
  bool _backendFailed = false;

  Future<void> registerDevice(AppUser user) async {
    if (_busy) return;

    _busy = true;

    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      debugPrint('Notification permission: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('Notification permission denied');
        return;
      }

      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      final token = await _messaging.getToken();

      debugPrint('NotificationService FCM token: $token');

      if (token == null || token.isEmpty) {
        debugPrint('FCM token empty, registration skipped');
        return;
      }

      if (_lastToken == token && _lastEmail == user.email) {
        debugPrint('FCM token already handled, skipped');
        return;
      }

      _lastToken = token;
      _lastEmail = user.email;

      await _tryRegisterToBackend(
        user: user,
        token: token,
      );

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        debugPrint('FCM token refreshed: $newToken');

        if (newToken.isEmpty) return;
        if (_lastToken == newToken && _lastEmail == user.email) return;

        _lastToken = newToken;
        _lastEmail = user.email;

        await _tryRegisterToBackend(
          user: user,
          token: newToken,
        );
      });
    } catch (error) {
      debugPrint('Notification registration skipped: $error');
    } finally {
      _busy = false;
    }
  }

  Future<void> _tryRegisterToBackend({
    required AppUser user,
    required String token,
  }) async {
    if (_backendFailed) {
      debugPrint('Backend notification registration already failed once, skipped');
      return;
    }

    final body = {
      'token': token,
      'email': user.email,
      'name': user.name,
    };

    try {
      debugPrint('Register notification payload: $body');

      await _api.post(
        '/api/v1/notification',
        data: body,
      );

      debugPrint('Notification token registered successfully');
    } on DioException catch (error) {
      _backendFailed = true;

      debugPrint('Notification backend registration failed');
      debugPrint('Status code: ${error.response?.statusCode}');
      debugPrint('Response data: ${error.response?.data}');
      debugPrint('Request path: ${error.requestOptions.path}');
      debugPrint('Request data: ${error.requestOptions.data}');
      debugPrint(
        'Firebase notification is still working. Backend endpoint /api/v1/notification needs server-side fix.',
      );
    } catch (error) {
      _backendFailed = true;
      debugPrint('Notification backend registration skipped: $error');
    }
  }
}