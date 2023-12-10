import 'package:fakestagram/main.dart';
import 'package:fakestagram/services/post_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token;

  void setupFirebase() async {
    final notificationSettings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    token = await messaging.getToken();
    userProvider.setFcmToken(token);
    print(">>>>>>>>>> FCM token: $token <<<<<<<<<<<");

    _setupFcmNotification();

    messaging.onTokenRefresh.listen((fcmToken) {
      token = fcmToken;
      userProvider.setFcmToken(token);
      // AuthService().sendDeviceId();
    }).onError((err) {
      debugPrint(">>>>>>>>>> Error getting fcm token <<<<<<<<<<<");
    });
  }

  void _setupFcmNotification() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print(">>>>>>>>>> FCM Notification received in app killed state <<<<<<<<<<<");
      if (initialMessage.notification != null) {
        handleMessage(initialMessage);
      }
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(">>>>>>>>>> FCM Notification received in app background state <<<<<<<<<<<");
      if (message.notification != null) {
        handleMessage(message);
      }
    });

    // To handle messages while your application is in the foreground,
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(">>>>>>>>>> FCM Notification received in app foreground state <<<<<<<<<<<");
      if (message.notification != null) {
        handleMessage(message);
      }
    });
  }

  void handleMessage(RemoteMessage message) {
    try {
      if (message.data['type'] == 'new_post') {
        PostService().getPostDetails(
          appProvider.globalNavigator!.currentContext!,
          message.data["post_id"],
        );
      }
    } catch (err) {
      print(">>>>>>>>>> FCM handler error: $err <<<<<<<<<<<");
    }
  }
}
