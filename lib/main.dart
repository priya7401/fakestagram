import 'package:fakestagram/providers/app_provider.dart';
import 'package:fakestagram/providers/user_provider.dart';
import 'package:fakestagram/utils/app_constants.dart';
import 'package:fakestagram/views/auth/sign_in.dart';
import 'package:fakestagram/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => AppProvider()),
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey:
          Provider.of<AppProvider>(context, listen: false).globalNavigator,
      title: 'Fakestagram',
      theme: ThemeData(
        primaryColor: AppConstants.primaryColor,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
