import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:safespeak/Services/firebase_options.dart';
import 'package:safespeak/main.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print("Basic_NotificationScreens Recieved ${message.notification!.title}");
}

class NotificationService {
  static Future<void> intialize() async {
    // ✅ Ensure Firebase is initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    try {
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission();

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print("✅ NotificationService initialized with permission.");
        FirebaseMessaging.onBackgroundMessage(backgroundHandler);
      } else {
        print("❌ Notification permission not granted.");
      }
    } catch (e) {
      print("🚨 Error initializing notifications: $e");
    }
  }

  static Future<void> getAppCheckToken() async {
    try {
      final token = await FirebaseAppCheck.instance.getToken(true);
      String? appCheckToken = await FirebaseAppCheck.instance.getToken();
      log("App Check Token: $appCheckToken");
    } catch (e) {
      print("Error fetching App Check token: $e");
    }
  }

  static Future<void> getToken() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
    }

    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        print("FCM Token: $token");
        addStringToSF(token);
      }
    } catch (e) {
      print("🚨 Error getting FCM token: $e");
    }
  }

  static void shownotification(RemoteMessage event) {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails("DropikMe", "APPNOTIFICATION",
            playSound: true,
            priority: Priority.max,
            importance: Importance.max);
    DarwinNotificationDetails iOSNotificationDetails =
        const DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iOSNotificationDetails);
    notificationsPlugin.show(0, event.notification!.title,
        event.notification!.body, notificationDetails);
  }

  static void addStringToSF(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Token', token);
  }
}
