import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safespeak/Services/Notification_Services_Local.dart';
import 'package:safespeak/Services/firebase_options.dart';
import 'package:safespeak/Support/MyHttpOverrides.dart';
import 'package:safespeak/view/onboarding/onboarding_view.dart';

/// Global variables
final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();
final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

late final FirebaseApp app;
late final FirebaseAuth auth;

/// Entry Point
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Allow custom HTTP overrides
  HttpOverrides.global = MyHttpOverrides();

  /// Lock orientation & system UI
  SystemChrome.setSystemUIOverlayStyle(defaultOverlay);
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  /// Initialize Firebase
  app = await Firebase.initializeApp(
    name: "com.example.safespeak",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  auth = FirebaseAuth.instanceFor(app: app);
  FirebaseAuth.instance.setLanguageCode('en');
  FirebaseAuth.instance.setSettings(forceRecaptchaFlow: true);

  /// Initialize services
  await NotificationService.intialize();
  await configureAppCheck(); // Correct AppCheck activation
  await NotificationService.getAppCheckToken();

  /// Local notifications setup
  await _initializeLocalNotifications();

  /// Firebase messaging setup
  _configureFirebaseMessaging();

  /// Crashlytics error handling
  FlutterError.onError = (errorDetails) =>
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  /// Start the app
  runApp(const ProviderScope(child: MyApp()));
}

/// Initialize local notifications
Future<void> _initializeLocalNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings("@mipmap/ic_launcher");
  const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
    defaultPresentSound: true,
    defaultPresentBadge: true,
    defaultPresentAlert: true,
  );
  const InitializationSettings initializationSettings =
      InitializationSettings(android: androidSettings, iOS: iosSettings);

  await notificationsPlugin.initialize(initializationSettings);
  await NotificationService.getToken();
}

/// Configure Firebase Messaging
void _configureFirebaseMessaging() {
  FirebaseMessaging.onMessage.listen((event) {
    NotificationService.shownotification(event);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    debugPrint("Push notification clicked: $event");
  });
}

/// AppCheck Configuration
Future<void> configureAppCheck() async {
  try {
    final AndroidProvider androidProvider =
        kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity;
    debugPrint('Using Android Provider: $androidProvider');

    await FirebaseAppCheck.instance.activate(
      androidProvider: androidProvider,
      webProvider:
          ReCaptchaV3Provider('6LfQ0pEqAAAAABQGAxyBR5A187Hm08WhaEksOC8B'),
    );

    /// Attempt token retrieval
    final token = await FirebaseAppCheck.instance.getToken(true);
    if (token != null) {
      debugPrint('✅ App Check Token retrieved (length: ${token.length})');
    } else {
      debugPrint('❌ App Check Token is null');
    }
  } catch (e) {
    debugPrint('🚨 App Check Error: $e');
    await fallbackAppCheckConfig();
  }
}

/// Fallback App Check
Future<void> fallbackAppCheckConfig() async {
  try {
    debugPrint('🔄 Attempting App Check Fallback');
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      webProvider:
          ReCaptchaV3Provider('6LfQ0pEqAAAAABQGAxyBR5A187Hm08WhaEksOC8B'),
    );
    await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(false);
    debugPrint('✅ Fallback App Check Configured');
  } catch (e) {
    debugPrint('❌ Fallback App Check Failed: $e');
  }
}

/// UI Overlay Config
SystemUiOverlayStyle defaultOverlay = const SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarColor: Colors.black,
  systemNavigationBarDividerColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.light,
);

/// Main App Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 844),
      useInheritedMediaQuery: true,
      minTextAdapt: true,
      builder: (context, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            useInheritedMediaQuery: true,
            title: 'SafeSpeak',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: OnboardingScreen(),
          ),
        );
      },
    );
  }
}
