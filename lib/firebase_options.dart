import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android: return android;
      case TargetPlatform.iOS: return ios;
      default: throw UnsupportedError('DefaultFirebaseOptions: Unsupported platform');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBls8f4cV1RpR9McxLBXlUgKGnQGR6WMuw',
    appId: '1:773465489771:web:c67cab339fa726f7ee8c2e',
    messagingSenderId: '773465489771',
    projectId: 'th3-cuahang',
    authDomain: 'th3-cuahang.firebaseapp.com',
    storageBucket: 'th3-cuahang.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCaJnCdJNn-xggRSPtQypKFPy6ziYbSI4Y',
    appId: '1:773465489771:android:12bba7e1917c9cbdee8c2e',
    messagingSenderId: '773465489771',
    projectId: 'th3-cuahang',
    storageBucket: 'th3-cuahang.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: '1:000:ios:XXXXXXXX',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'th3-cuahang',
    iosBundleId: 'com.example.app',
  );
}
