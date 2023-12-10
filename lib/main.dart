import 'dart:convert';

import 'package:fakestagram/models/user.dart';
import 'package:fakestagram/providers/providers.dart';
import 'package:fakestagram/services/firebase_service.dart';
import 'package:fakestagram/services/services.dart';
import 'package:fakestagram/utils/app_constants.dart';
import 'package:fakestagram/views/init_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  firebaseService.handleMessage(message);

  debugPrint("Handling a background message: ${message.messageId}");
}

FirebaseService firebaseService = FirebaseService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => AppProvider()),
      ChangeNotifierProvider(create: (context) => PostsProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setPrefsData();
    });
  }

  void setPrefsData() async {
    final AppProvider appProvider = Provider.of<AppProvider>(
      context,
      listen: false,
    );
    final UserProvider userProvider = Provider.of<UserProvider>(
      appProvider.globalNavigator!.currentContext ?? context,
      listen: false,
    );
    try {
      final prefs = await SharedPreferences.getInstance();

      appProvider.setLoader(true);
      if (prefs.containsKey('token')) {
        final prefToken = prefs.getString('token');
        if (prefToken != null && prefToken != '') {
          userProvider.setToken(prefToken);
          UserService().getUserDetails(appProvider.globalNavigator!.currentContext ?? context);
          PostService().getFeed(appProvider.globalNavigator!.currentContext ?? context);
        }
      }
    if (prefs.containsKey('user')) {
      final prefUser = prefs.getString('user');
      if (prefUser != null && prefUser != '') {
        userProvider.setUser(User.fromJson(jsonDecode(prefUser)));
      }
      }
      firebaseService.setupFirebase(userProvider);
      appProvider.setLoader(false);
    } catch (err) {
      appProvider.setLoader(false);
      print(">>>>>>>>>>> App prefs init error: $err <<<<<<<<<<<<");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, child) {
      return MaterialApp(
        navigatorKey: appProvider.globalNavigator,
        title: 'Fakestagram',
        theme: ThemeData(
          primaryColor: AppConstants.primaryColor,
          // primarySwatch: swatchify(Colors.pink, 300),
          appBarTheme: AppBarTheme(
            color: AppConstants.primaryColor,
          ),
          buttonTheme: ButtonThemeData(buttonColor: AppConstants.primaryColor),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(backgroundColor: AppConstants.primaryColor),
          ),
        ),
        home: const InitPage(),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
