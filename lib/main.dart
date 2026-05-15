import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/app.dart';
import 'package:rbc_flutter_professional/core/services/rbc_firebase_notification_service.dart';
import 'package:rbc_flutter_professional/core/services/rbc_notification_service.dart';
import 'package:rbc_flutter_professional/firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:provider/provider.dart';
import 'package:rbc_flutter_professional/providers/village_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('❌ Firebase init error: $e');
  }

  tz.initializeTimeZones();

  try {
    await RbcNotificationService.init();
  } catch (e) {
    debugPrint('❌ Local reminder notification error: $e');
  }

  try {
    await RbcFirebaseNotificationService.init();
  } catch (e) {
    debugPrint('❌ Firebase push notification error: $e');
  }

  // runApp(const RbcApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => VillageProvider()..fetchAllPeople(), 
        ),
      ],
      child: const RbcApp(),
    ),
  );
}