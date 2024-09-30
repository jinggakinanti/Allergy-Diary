// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  final LinearGradient _gradient = LinearGradient(
    colors: <Color>[
      Color.fromRGBO(63, 142, 233, 1),
      Color.fromRGBO(69, 117, 171, 1),
    ],
  );

  void passwordReset() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      showErrorDialog('Please enter your email address.');
      return;
    }

    try {
      // Attempt to send the password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showErrorDialog('Password reset link sent! Check Your Email');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorDialog('No account found with this email address.');
      } else {
        showErrorDialog('Error sending password reset email: ${e.message}');
      }
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Center(
          child: Text(message,
              style: TextStyle(
                  fontFamily: 'Kadwa',
                  fontSize: 15,
                  fontWeight: FontWeight.w500)),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(fontFamily: 'Outfit', fontSize: 25),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.chevron_left)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              SizedBox(height: 100),

              //! Alergy Diary
              ShaderMask(
                  shaderCallback: (Rect rect) {
                    return _gradient.createShader(rect);
                  },
                  child: Text('Allergy Diary',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 45,
                              fontFamily: 'Kadwa'))),

              SizedBox(height: 50),

              //! Email TextBox
              Text('Enter Your Email',
                  style: TextStyle(fontSize: 20, fontFamily: 'Kadwa')),
              const SizedBox(height: 5),
              TextField(
                controller: emailController,
                obscureText: false,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  fillColor: Color.fromRGBO(243, 246, 250, 1),
                  filled: true,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),

              SizedBox(height: 25),

              //! Forgot Button Button
              GestureDetector(
                onTap: passwordReset,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(143, 173, 222, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontFamily: 'Kadwa',
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
