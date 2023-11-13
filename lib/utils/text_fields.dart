import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController? textEditingController;
  final TextEditingController? passwordController;
  final bool? isConfirmPassword;
  const PasswordTextField({
    super.key,
    this.textEditingController,
    this.isConfirmPassword = false,
    this.passwordController,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      decoration: InputDecoration(
          hintText: 'Enter password',
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
          )),
      obscureText: !_passwordVisible,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Error! password cannot be empty";
        } else {
          if (widget.isConfirmPassword == true &&
              value != widget.passwordController?.text) {
            return "Error! Please enter same password as above";
          } else if (value.length < 8) {
            return "Password must be of atleast 8 characters in length";
          }
        }
        return null;
      },
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final bool? isEmail;
  final String? hintText;
  final String? fieldName;
  final bool? isRequired;
  final String? initialText;
  const CustomTextField({
    super.key,
    this.textEditingController,
    this.isEmail = false,
    this.hintText,
    this.fieldName,
    this.isRequired = true,
    this.initialText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (String? value) {
        if (isRequired == true && value != initialText) {
          if (value == null || value.isEmpty) {
            return "Error! ${fieldName ?? "field"} cannot be empty";
          } else if (isEmail ?? false) {
            if (!EmailValidator.validate(value)) {
              return "Please enter valid email Id";
            }
          }
          return null;
        }
        return null;
      },
    );
  }
}
