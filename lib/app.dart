import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbc_flutter_professional/core/config/app_config.dart';
import 'package:rbc_flutter_professional/core/services/rbc_firebase_notification_service.dart';
import 'package:rbc_flutter_professional/core/theme/app_theme.dart';
import 'package:rbc_flutter_professional/features/auth/auth_controller.dart';
import 'package:rbc_flutter_professional/features/auth/sign_in_screen.dart';
import 'package:rbc_flutter_professional/features/shell/app_shell.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_splash.dart';

class RbcApp extends StatelessWidget {
  const RbcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthController>(
      create: (_) {
        final controller = AuthController();
        controller.bootstrap();
        return controller;
      },
      child: MaterialApp(
        navigatorKey: RbcFirebaseNotificationService.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: AppConfig.appName,
        theme: AppTheme.light,
        home: const _AuthGate(),
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, auth, _) {
        if (auth.isBootstrapping) {
          return const ProSplashScreen();
        }

        if (!auth.isAuthenticated) {
          return const SignInScreen();
        }

        return const AppShell();
      },
    );
  }
}