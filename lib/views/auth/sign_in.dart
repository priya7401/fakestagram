import 'package:email_validator/email_validator.dart';
import 'package:fakestagram/providers/providers.dart';
import 'package:fakestagram/services/services.dart';
import 'package:fakestagram/utils/global_widgets.dart';
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
        resizeToAvoidBottomInset: false,
        body: Padding(
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
                      decoration: InputDecoration(hintText: 'Enter password'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Error! password cannot be empty";
                        } else if (value.length < 8) {
                          return "Password must be of atleast 8 characters in length";
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
              InkWell(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    AuthService().signIn({
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
                    color: Colors.pink[100],
                  ),
                  child: userProvider.isLoading
                      ? Center(
                          child: progressIndicator(),
                        )
                      : const Text('Sign In'),
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
        ),
      ));
    });
  }
}
