import 'package:fakestagram/providers/providers.dart';
import 'package:fakestagram/utils/app_constants.dart';
import 'package:fakestagram/views/init_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey:
          Provider.of<AppProvider>(context, listen: false).globalNavigator,
      title: 'Fakestagram',
      theme: ThemeData(
        primaryColor: AppConstants.primaryColor,
        // primarySwatch: swatchify(Colors.pink, 300),
        appBarTheme: AppBarTheme(
          color: AppConstants.primaryColor,
        ),
        buttonTheme: ButtonThemeData(buttonColor: AppConstants.primaryColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor),
        ),
      ),
      home: const InitPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
