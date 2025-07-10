import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:safespeak/Services/Notification_Services_Local.dart';
import 'package:safespeak/Services/SocketManager.dart';
import 'package:safespeak/Services/firebase_options.dart';
import 'package:safespeak/Support/MyHttpOverrides.dart';
import 'package:safespeak/view/onboarding/onboarding_view.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

late final FirebaseApp app;
late final FirebaseAuth auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setSystemUIOverlayStyle(defaultOverlay);
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  app = await Firebase.initializeApp(
    name: "com.example.safespeak",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  auth = FirebaseAuth.instanceFor(app: app);
  FirebaseAuth.instance.setLanguageCode('en'); // Or any other locale code
  FirebaseAuth.instance.setSettings(forceRecaptchaFlow: true);
  await NotificationService.intialize();
  await NotificationService.getAppCheckToken();
  AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings("@mipmap/ic_launcher");
  DarwinInitializationSettings iosSettings = const DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      defaultPresentSound: true,
      defaultPresentBadge: true,
      defaultPresentAlert: true);
  InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings, iOS: iosSettings);
  ////*     ^^This Line Is Used For Ios Devices Or Android Basic_NotificationScreens Settings Manage^^     *////

  bool? initialize =
      await notificationsPlugin.initialize(initializationSettings);
  NotificationService.getToken();
  FirebaseMessaging.onMessage.listen((event) {
    NotificationService.shownotification(event);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(1);
  });

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final socketManager = SocketManager();
  socketManager.connectWithRetry();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 844),
      useInheritedMediaQuery: true,
      minTextAdapt: true,
      builder: (context, child) {
        return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              useInheritedMediaQuery: true,
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: OnboardingScreen(),
            ));
      },
    );
  }
}

SystemUiOverlayStyle defaultOverlay = const SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarColor: Colors.black,
  systemNavigationBarDividerColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.light,
);

void checkPlayIntegrityStatus() async {
  try {
    // Check Play Services availability
    GooglePlayServicesAvailability playServicesAvailable =
        await GoogleApiAvailability.instance
            .checkGooglePlayServicesAvailability();
    print('Play Services Status: $playServicesAvailable');

    // Additional device integrity checks
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    print('Device Model: ${androidInfo.model}');
    print('Android Version: ${androidInfo.version.release}');
    print('Is Physical Device: ${androidInfo.isPhysicalDevice}');
  } catch (e) {
    print('Integrity Check Error: $e');
  }
}

Future<void> configureAppCheck() async {
  try {
    // Determine appropriate provider based on environment
    AndroidProvider androidProvider =
        kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity;

    print('Using Android Provider: $androidProvider');

    // Activate App Check with explicit error handling
    await FirebaseAppCheck.instance.activate(
      androidProvider: androidProvider,
      webProvider:
          ReCaptchaV3Provider('6LfQ0pEqAAAAABQGAxyBR5A187Hm08WhaEksOC8B'),
    );

    // Attempt token retrieval with comprehensive logging
    try {
      final token = await FirebaseAppCheck.instance.getToken(true);
      if (token != null) {
        print('✅ App Check Token successfully retrieved');
        print('Token Length: ${token.length}');
      } else {
        print('❌ App Check Token is null');
      }
    } on FirebaseException catch (tokenError) {
      print('❌ App Check Token Retrieval Failed');
      print('Error Code: ${tokenError.code}');
      print('Error Message: ${tokenError.message}');
      print('Full Error: $tokenError');

      // Fallback mechanism
      await fallbackAppCheckConfig();
    }
  } catch (e) {
    print('🚨 Unexpected App Check Configuration Error: $e');
    await fallbackAppCheckConfig();
  }
}

Future<void> fallbackAppCheckConfig() async {
  try {
    print('🔄 Attempting App Check Fallback Configuration');

    AndroidProvider androidProvider =
        kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity;

    // Attempt debug provider
    await FirebaseAppCheck.instance.activate(
      androidProvider: androidProvider,
      webProvider:
          ReCaptchaV3Provider('6LfQ0pEqAAAAABQGAxyBR5A187Hm08WhaEksOC8B'),
    );

    // Disable auto-refresh to prevent continuous failures
    await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(false);

    print('✅ Fallback App Check Configuration Successful');
  } catch (e) {
    print('❌ Fallback App Check Configuration Failed: $e');
  }
}
