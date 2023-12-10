import 'package:fakestagram/providers/providers.dart';
import 'package:fakestagram/views/auth/sign_in.dart';
import 'package:fakestagram/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitPage extends StatelessWidget {
  const InitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, AppProvider>(builder: (context, userProvider, appProvider, child) {
      return Scaffold(
        body: appProvider.isLoading
            ? AppLoadingScreen()
            : userProvider.user != null && userProvider.user?.id != null
                ? const HomePage()
                : const SignIn(),
      );
    });
  }
}

class AppLoadingScreen extends StatelessWidget {
  const AppLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.asset("assets/Rhombus.gif"),
        ),
      ),
    );
  }
}
