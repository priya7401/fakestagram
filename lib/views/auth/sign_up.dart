import 'package:email_validator/email_validator.dart';
import 'package:fakestagram/providers/providers.dart';
import 'package:fakestagram/services/services.dart';
import 'package:fakestagram/utils/app_constants.dart';
import 'package:fakestagram/utils/global_widgets.dart';
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
  bool _passwordVisible = false;
  bool _confirmPasswordvisible = false;

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
                        TextFormField(
                          controller: username,
                          decoration:
                              InputDecoration(hintText: 'Enter username'),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Error! Username cannot be empty";
                            }
                            return null;
                          },
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
                        TextFormField(
                          controller: email,
                          decoration: InputDecoration(hintText: 'Enter email'),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Error! Email cannot be empty";
                            } else if (!EmailValidator.validate(value)) {
                              return "Please enter valid email Id";
                            }
                            return null;
                          },
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
                        TextFormField(
                          controller: password,
                          decoration: InputDecoration(
                              hintText: 'Enter password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              )),
                          obscureText: !_passwordVisible,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Error! password cannot be empty";
                            } else if (value.length < 8) {
                              return "Password must be of atleast 8 characters in length";
                            }
                            return null;
                          },
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
                        TextFormField(
                          controller: confirmPassword,
                          decoration:
                              InputDecoration(
                              hintText: 'Enter password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _confirmPasswordvisible =
                                        !_confirmPasswordvisible;
                                  });
                                },
                                icon: Icon(
                                  _confirmPasswordvisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              )),
                          obscureText: !_confirmPasswordvisible,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Error! password cannot be empty";
                            } else if (value != password.text) {
                              return "Error! Please enter same password as above";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 0,
                    height: 50,
                  ),
                  //button for login
                  InkWell(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        AuthService().signUp({
                          "username": username.text.trim(),
                          "email": email.text.trim(),
                          "password": password.text.trim()
                        }, context);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        color: AppConstants.primaryColor,
                      ),
                      child: userProvider.isLoading
                          ? Center(
                              child: progressIndicator(),
                            )
                          : const Text('Sign Up'),
                    ),
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
