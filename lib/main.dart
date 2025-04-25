import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:leeds_library/core/env/env_config.dart';
import 'data/models/book.dart';
import 'firebase_options.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/di/di_container.dart' as di;
import 'package:hive_flutter/adapters.dart';

import 'presentation/app/my_app.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final envConfig = await _initEnv();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Setup notifications
  // Setup notifications
  await _setupPushNotifications();

  // ❗ Перевірка, чи відкрили додаток з повідомлення (terminated)
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }

  // ❗ Відкриття з фону по пушу
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

  // Initialize date formatting
  await initializeDateFormatting('en_GB', null);

  // Initialize Hive and register adapters
  await _initHive();

  // Load environment variables and determine mock data source

  if (envConfig.useFirestoreEmulator == 'true') {
    await _connectToFirebaseEmulator();
  }

  // Initialize dependencies
  await di.init(baseUrl: envConfig.baseUrl, postfix: envConfig.postfix);

  // Initialize localization
  final delegate = await _initLocalization();



  // Run the app
  runApp(LocalizedApp(delegate, const MyApp()));
}

/// Initializes Hive storage and registers adapters.
Future<void> _initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(BookAdapter()); // Реєстрація адаптера

  final bookBox = await Hive.openBox<Book>('books');
}


Future<EnvConfig> _initEnv() async {

  var envConfig = EnvConfig('http://192.168.0.25:5001/library-541e4/us-central1', '-dev', 'true');

  try {
    await dotenv.load(fileName: ".env");
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://192.168.0.25:5001/library-541e4/us-central1';
    final postfix = dotenv.env['POSTFIX'] ?? '';
    final useFirestoreEmulator = dotenv.env['USE_FIRESTORE_EMULATOR'] ?? 'true';
    envConfig = EnvConfig(baseUrl, postfix,useFirestoreEmulator);
  } catch (e) {
    if (kDebugMode) {
      debugPrint("Warning: .env file not found. Using default values.");
    }
  }
  if (kDebugMode) {
    debugPrint("envConfig url: ${envConfig.baseUrl}");
  }
  return envConfig;
}

// flutter run --dart-define=USE_FIREBASE_EMULATOR=true
Future<void> _connectToFirebaseEmulator() async {
  const localhost = '192.168.0.25';//'10.0.2.2';

  FirebaseFirestore.instance.useFirestoreEmulator(localhost, 8080);
  //FirebaseAuth.instance.useAuthEmulator(localhost, 9099);
  //FirebaseFunctions.instance.useFunctionsEmulator(localhost, 5001);

  print('✅ Connected to Firebase emulators');
}

/// Initializes localization settings.
Future<LocalizationDelegate> _initLocalization() async {
  return await LocalizationDelegate.create(
    fallbackLocale: 'en',
    supportedLocales: ['en', 'cs'],
  );
}


Future<void> _setupPushNotifications() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;


  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
  print('Push permission status: ${settings.authorizationStatus}');

  // Отримання FCM токена
  final fcmToken = await messaging.getToken();
  print('FCM Token: $fcmToken');

  // Збереження токена в Firestore
  final user = FirebaseAuth.instance.currentUser;
  if (user != null && fcmToken != null) {
    await FirebaseFirestore.instance
        .collection('users-dev')
        .doc(user.uid)
        .update({'fcmToken': fcmToken});
  }

  // Обробка повідомлень у foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📩 Push received in foreground!');
    print('🔔 Title: ${message.notification?.title}');
    print('📝 Body: ${message.notification?.body}');
    // TODO: показати сповіщення в UI або SnackBar
  });

  // Обробка натискань по пушу (при відкритті)
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('🚀 User tapped on notification');
    // TODO: навігація на екран з деталями книги
  });


}

void _handleMessage(RemoteMessage message) {
  final data = message.data;
  final bookId = data['bookId'];

  print('🚀 User tapped push. Book ID: $bookId');

  // TODO: Навігація на екран книги або інше
}


