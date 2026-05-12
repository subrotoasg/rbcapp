import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rbc_flutter_professional/core/services/app_action_service.dart';
import 'package:rbc_flutter_professional/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('❌ FCM background Firebase init error: $e');
  }

  debugPrint('📩 FCM BACKGROUND MESSAGE ID: ${message.messageId}');
  debugPrint('📩 FCM BACKGROUND DATA: ${message.data}');
}

class RbcFirebaseNotificationService {
  RbcFirebaseNotificationService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const AndroidNotificationChannel _channel =
      AndroidNotificationChannel(
    'rbc_high_importance_channel',
    'RBC Notifications',
    description: 'রূপসী বাংলা ক্লাবের গুরুত্বপূর্ণ নোটিফিকেশন',
    importance: Importance.high,
  );

  static Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _requestPermission();
    await _initLocalNotifications();
    await _createAndroidChannel();
    await _setupToken();

    _listenForegroundMessages();
    _listenNotificationTapFromBackground();

    await _handleNotificationTapFromTerminated();
  }

  static Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    debugPrint('🔔 FCM PERMISSION: ${settings.authorizationStatus}');

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;

        if (payload == null || payload.trim().isEmpty) return;

        try {
          final decoded = jsonDecode(payload);

          if (decoded is Map) {
            _handleNavigation(Map<String, dynamic>.from(decoded));
          }
        } catch (e) {
          debugPrint('❌ LOCAL NOTIFICATION PAYLOAD ERROR: $e');
        }
      },
    );
  }

  static Future<void> _createAndroidChannel() async {
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(_channel);
    await androidPlugin?.requestNotificationsPermission();
  }

  static Future<void> _setupToken() async {
    final token = await _messaging.getToken();

    debugPrint('✅ FCM TOKEN: $token');

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint('🔁 FCM TOKEN REFRESHED: $newToken');

      // এখানে backend-এ token save করতে পারেন।
      // Example:
      // ApiClient.instance.post('/api/fcm-token', data: {'token': newToken});
    });
  }

  static void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('📩 FCM FOREGROUND MESSAGE ID: ${message.messageId}');
      debugPrint('📩 FCM FOREGROUND DATA: ${message.data}');

      final push = RbcPushMessage.fromRemoteMessage(message);

      await _showForegroundNotification(push);
    });
  }

  static void _listenNotificationTapFromBackground() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('📲 FCM OPENED FROM BACKGROUND: ${message.data}');

      final push = RbcPushMessage.fromRemoteMessage(message);
      _handleNavigation(push.data);
    });
  }

  static Future<void> _handleNotificationTapFromTerminated() async {
    final message = await _messaging.getInitialMessage();

    if (message == null) return;

    debugPrint('📲 FCM OPENED FROM TERMINATED: ${message.data}');

    final push = RbcPushMessage.fromRemoteMessage(message);

    Future.delayed(const Duration(milliseconds: 900), () {
      _handleNavigation(push.data);
    });
  }

  static Future<void> _showForegroundNotification(RbcPushMessage push) async {
    final styleInformation = await _buildBigPictureStyle(push);

    await _localNotifications.show(
      push.notificationId,
      push.title,
      push.description,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: styleInformation,
          ticker: 'রূপসী বাংলা ক্লাব',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(push.data),
    );
  }

  static Future<BigPictureStyleInformation?> _buildBigPictureStyle(
    RbcPushMessage push,
  ) async {
    if (push.imageUrl.isEmpty) return null;

    try {
      final path = await _downloadImage(push.imageUrl);
      final bitmap = FilePathAndroidBitmap(path);

      return BigPictureStyleInformation(
        bitmap,
        largeIcon: bitmap,
        contentTitle: push.title,
        summaryText: push.description,
        hideExpandedLargeIcon: false,
      );
    } catch (e) {
      debugPrint('❌ FCM IMAGE DOWNLOAD FAILED: $e');
      return null;
    }
  }

  static Future<String> _downloadImage(String imageUrl) async {
    final fileName = 'rbc_push_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = '${Directory.systemTemp.path}/$fileName';

    await Dio().download(
      imageUrl,
      filePath,
      options: Options(
        receiveTimeout: const Duration(seconds: 12),
        sendTimeout: const Duration(seconds: 12),
      ),
    );

    return filePath;
  }

  static void _handleNavigation(Map<String, dynamic> data) {
    final context = navigatorKey.currentContext;
    final navigator = navigatorKey.currentState;

    if (context == null || navigator == null) {
      debugPrint('⚠️ FCM NAVIGATION FAILED: navigator not ready');
      return;
    }

    final deepLink = _readString(data, [
      'deepLink',
      'deeplink',
      'link',
      'url',
    ]);

    final screen = _readString(data, [
      'screen',
      'route',
      'page',
    ]);

    final id = _readString(data, [
      'id',
      'postId',
      'eventId',
    ]);

    debugPrint('📲 FCM NAVIGATION: deepLink=$deepLink screen=$screen id=$id');

    if (deepLink.isNotEmpty) {
      AppActionService.openInsideApp(
        context,
        'রূপসী বাংলা ক্লাব',
        deepLink,
      );
      return;
    }

    switch (screen) {
      case 'event':
      case 'events':
        // navigator.push(MaterialPageRoute(builder: (_) => const EventHubScreen()));
        break;

      case 'post':
      case 'posts':
        // navigator.push(MaterialPageRoute(builder: (_) => const PostsScreen()));
        break;

      case 'calendar':
      case 'panchika':
        // navigator.push(MaterialPageRoute(builder: (_) => const PanchikaScreen()));
        break;

      default:
        break;
    }
  }

  static String _readString(
    Map<String, dynamic> data,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = data[key];
      final text = '${value ?? ''}'.trim();

      if (text.isNotEmpty && text != 'null') {
        return text;
      }
    }

    return '';
  }
}

class RbcPushMessage {
  const RbcPushMessage({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.data,
    required this.notificationId,
  });

  final String title;
  final String description;
  final String imageUrl;
  final Map<String, dynamic> data;
  final int notificationId;

  factory RbcPushMessage.fromRemoteMessage(RemoteMessage message) {
    final notification = message.notification;
    final data = Map<String, dynamic>.from(message.data);

    final title = _firstText([
      data['title'],
      data['notificationTitle'],
      notification?.title,
      'রূপসী বাংলা ক্লাব',
    ]);

    final description = _firstText([
      data['description'],
      data['body'],
      data['message'],
      notification?.body,
      'আপনার জন্য নতুন একটি আপডেট আছে।',
    ]);

    final imageUrl = _firstText([
      data['image'],
      data['imageUrl'],
      data['picture'],
      data['photo'],
      notification?.android?.imageUrl,
      notification?.apple?.imageUrl,
    ]);

    final idText = _firstText([
      data['notificationId'],
      data['id'],
      message.messageId,
      DateTime.now().millisecondsSinceEpoch,
    ]);

    final notificationId = idText.hashCode.abs().remainder(2147483647);

    final mergedData = {
      ...data,
      'title': title,
      'description': description,
      'image': imageUrl,
    };

    return RbcPushMessage(
      title: title,
      description: description,
      imageUrl: imageUrl,
      data: mergedData,
      notificationId: notificationId,
    );
  }

  static String _firstText(List<dynamic> values) {
    for (final value in values) {
      final text = '${value ?? ''}'.trim();

      if (text.isNotEmpty && text != 'null') {
        return text;
      }
    }

    return '';
  }
}