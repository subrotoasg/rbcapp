import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/app.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:rbc_flutter_professional/core/services/rbc_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (_) {
  }

  tz.initializeTimeZones();

  try {
    await RbcNotificationService.init();
  } catch (_) {
  }

  runApp(const RbcApp());
}