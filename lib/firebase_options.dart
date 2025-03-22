import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError('FirebaseOptions not configured for this platform.');
      default:
        throw UnsupportedError('Unknown platform.');
    }
  }

  static FirebaseOptions get web => FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY_WEB']!,
    appId: dotenv.env['FIREBASE_APP_ID_WEB']!,
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
    projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
    authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'],
    databaseURL: dotenv.env['FIREBASE_DATABASE_URL'],
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
    measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'],
  );

  static FirebaseOptions get android => FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY_ANDROID']!,
    appId: dotenv.env['FIREBASE_APP_ID_ANDROID']!,
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
    projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
    databaseURL: dotenv.env['FIREBASE_DATABASE_URL'],
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
  );

  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY_IOS']!,
    appId: dotenv.env['FIREBASE_APP_ID_IOS']!,
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
    projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
    databaseURL: dotenv.env['FIREBASE_DATABASE_URL'],
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
    iosClientId: dotenv.env['FIREBASE_IOS_CLIENT_ID'],
    iosBundleId: dotenv.env['FIREBASE_IOS_BUNDLE_ID'],
  );
}
