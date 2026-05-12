import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions is configured for Android only.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBa8tGujwiswlUdF4eg2YBSWfAr5yFVctI',
    appId: '1:919632471361:android:8d3f7e798e2f047573edc0',
    messagingSenderId: '919632471361',
    projectId: 'rbcimage-aed61',
    storageBucket: 'rbcimage-aed61.appspot.com',
  );
}