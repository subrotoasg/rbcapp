import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/features/auth/user_model.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();
  final _messaging = FirebaseMessaging.instance;
  final _api = ApiClient.instance;

  Future<void> registerDevice(AppUser user) async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      final token = await _messaging.getToken();
      if (token == null || token.isEmpty) return;
      await _api.post('/api/v1/notification', data: {
        'token': token,
        'email': user.email,
        'name': user.name,
      });
    } catch (error) {
      debugPrint('Notification registration skipped: $error');
    }
  }
}
