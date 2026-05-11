import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class RbcNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
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

    await _plugin.initialize(settings);

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> scheduleEventReminder({
    required String title,
    required DateTime eventDate,
    String? note,
  }) async {
    final reminderDate = eventDate.subtract(const Duration(days: 1));

    if (!reminderDate.isAfter(DateTime.now())) return;

    final id = eventDate.millisecondsSinceEpoch.remainder(2147483647);

    final body = note == null || note.trim().isEmpty
        ? 'রূপসী বাংলা ক্লাব আপনাকে স্মরণ করিয়ে দিচ্ছে আগামীকাল "$title" ইভেন্ট রয়েছে।'
        : 'রূপসী বাংলা ক্লাব আপনাকে স্মরণ করিয়ে দিচ্ছে আগামীকাল "$title" ইভেন্ট রয়েছে। বিস্তারিত: $note';

    await _plugin.zonedSchedule(
      id,
      'রূপসী বাংলা ক্লাব',
      body,
      tz.TZDateTime.from(reminderDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'rbc_event_reminders',
          'RBC Event Reminders',
          channelDescription: 'রূপসী বাংলা ক্লাব ইভেন্ট রিমাইন্ডার',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}