import 'package:fakestagram/providers/providers.dart';
import 'package:fakestagram/services/services.dart';
import 'package:fakestagram/utils/global_widgets.dart';
import 'package:fakestagram/utils/text_fields.dart';
import 'package:fakestagram/views/auth/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Fakestagram',
                style: TextStyle(fontSize: 40),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 0,
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 0,
                      height: 20,
                    ),
                    CustomTextField(
                      textEditingController: email,
                      hintText: 'Enter email',
                      fieldName: 'email',
                      isEmail: true,
                    ),
                    SizedBox(
                      width: 0,
                      height: 50,
                    ),
                    Text(
                      'Password',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 0,
                      height: 10,
                    ),
                    PasswordTextField(
                      textEditingController: password,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 0,
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: userProvider.isLoading
                  ? ProgressIndicatorButton()
                  : SubmitButton(
                      buttonText: 'Sign In',
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          AuthService().signIn({
                            "email": email.text.trim(),
                            "password": password.text.trim()
                          }, context);
                        }
                      },
                    ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text("Don't have an account?"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      " Sign Up!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ));
    });
  }
}
