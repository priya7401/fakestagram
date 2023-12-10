import 'package:fakestagram/providers/user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token;

  void setupFirebase(UserProvider userProvider) async {
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
      debugPrint(">>>>>>>>>> FCM Notification received in app killed state <<<<<<<<<<<");
      handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint(">>>>>>>>>> FCM Notification received in app background state <<<<<<<<<<<");
      handleMessage(message);
    });

    // To handle messages while your application is in the foreground,
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(">>>>>>>>>> FCM Notification received in app foreground state <<<<<<<<<<<");
      if (message.notification != null) {
        handleMessage(message);
      }
    });
  }

  void handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'new_post') {}
  }
}
