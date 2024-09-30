// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:project/page/LoginPage.dart';
import 'package:project/page/SignUpPage.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(showSignUpPage: togglePages);
    } else {
      return SignUpPage(showLoginPage: togglePages);
    }
  }
}
