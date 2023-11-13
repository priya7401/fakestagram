import 'package:fakestagram/providers/providers.dart';
import 'package:fakestagram/services/services.dart';
import 'package:fakestagram/utils/global_widgets.dart';
import 'package:fakestagram/utils/text_fields.dart';
import 'package:fakestagram/views/auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  // bool _passwordVisible = false;
  // bool _confirmPasswordvisible = false;

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    password.dispose();
    email.dispose();
    confirmPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
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
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Username',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 0,
                          height: 20,
                        ),
                        CustomTextField(
                          textEditingController: username,
                          hintText: 'Enter username',
                          fieldName: 'username',
                        ),
                        SizedBox(
                          width: 0,
                          height: 50,
                        ),
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
                        SizedBox(
                          width: 0,
                          height: 50,
                        ),
                        Text(
                          'Confirm Password',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 0,
                          height: 10,
                        ),
                        PasswordTextField(
                          textEditingController: confirmPassword,
                          isConfirmPassword: true,
                          passwordController: password,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 0,
                    height: 80,
                  ),
                  //button for login
                  userProvider.isLoading
                      ? ProgressIndicatorButton()
                      : SubmitButton(
                          buttonText: 'Sign Up',
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              AuthService().signUp({
                                "username": username.text.trim(),
                                "email": email.text.trim(),
                                "password": password.text.trim()
                              }, context);
                            }
                          },
                        ),
                  const SizedBox(
                    height: 12,
                  ),

                  //transition to signup
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text("Already have an account?"),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => SignIn()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            " Login!",
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
            ),
          ),
        ),
      );
    });
  }
}
