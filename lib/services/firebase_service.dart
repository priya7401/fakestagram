import 'package:fakestagram/main.dart';
import 'package:fakestagram/services/auth_service.dart';
import 'package:fakestagram/services/post_service.dart';
import 'package:fakestagram/services/user_service.dart';
import 'package:fakestagram/utils/app_constants.dart';
import 'package:fakestagram/views/home/profile_tab/followers_tab/follow_requests_page.dart';
import 'package:fakestagram/views/home/profile_tab/post_detail_view.dart';
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
    AuthService().sendDeviceId(appProvider.globalNavigator!.currentContext!);

    messaging.onTokenRefresh.listen((fcmToken) {
      token = fcmToken;
      userProvider.setFcmToken(token);
      // AuthService().sendDeviceId();
    }).onError((err) {
      debugPrint(">>>>>>>>>> Error getting fcm token <<<<<<<<<<<");
    });
  }

  void setupFcmNotification() async {
    print(">>>>>>>>>> setting up FCM notification handlers <<<<<<<<<<<");

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
    print('//////////message: ${message.data}');
    try {
      if (message.data['type'] == 'new_post') {
        PostService().getPostDetails(
          appProvider.globalNavigator!.currentContext!,
          message.data["post_id"],
        );
      }
      if (message.data['type'] == 'post_like') {
        PostService().getPosts(appProvider.globalNavigator!.currentContext!);
        Navigator.of(appProvider.globalNavigator!.currentContext!).push(
          MaterialPageRoute(
              builder: (context) => PostsDetailView(
                    user: PostDetailView.user.name,
                  )),
        );
      }
      if (message.data['type'] == 'follow_request') {
        UserService().followRequestList(appProvider.globalNavigator!.currentContext!);
        Navigator.of(appProvider.globalNavigator!.currentContext!).push(
          MaterialPageRoute(builder: (context) => FollowRequestsPage()),
        );
      }
    } catch (err) {
      print(">>>>>>>>>> FCM handler error: $err <<<<<<<<<<<");
    }
  }
}
