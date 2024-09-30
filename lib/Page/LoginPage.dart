// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Page/HomePage.dart';
import 'package:project/components/ForgotPass.dart';
import 'package:project/services/googleService.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showSignUpPage;
  const LoginPage({super.key, required this.showSignUpPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true;

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  final LinearGradient _gradient = LinearGradient(
    colors: <Color>[
      Color.fromRGBO(63, 142, 233, 1),
      Color.fromRGBO(69, 117, 171, 1),
    ],
  );

  void validateEmail() {
    final bool isValid = EmailValidator.validate(emailController.text.trim());

    if (isValid) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(title: Text('Valid Email'));
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(title: Text('Not a Valid Email'));
        },
      );
    }
  }

  Future<void> login() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showErrorDialog('Email and password cannot be empty');
      return;
    }
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          showErrorDialog('No user found for that email.');
        } else if (e.code == 'invalid-credential') {
          showErrorDialog('Wrong password provided for that user.');
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
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 50,
                        fontFamily: 'Leckerli'))),

            SizedBox(height: 30),

            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //! Email TextBox
              Text('Email',
                  style: TextStyle(fontSize: 17, fontFamily: 'Outfit')),
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

              SizedBox(height: 20),

              //! Password TextBox
              Text('Password',
                  style: TextStyle(fontSize: 17, fontFamily: 'Outfit')),
              TextField(
                controller: passwordController,
                obscureText: obscureText,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    fillColor: Color.fromRGBO(243, 246, 250, 1),
                    filled: true,
                    contentPadding: EdgeInsets.all(10),
                    suffixIcon: GestureDetector(
                      onTap: togglePasswordVisibility,
                      child: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                    )),
              ),

              SizedBox(height: 5),

              //! Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ForgotPassword();
                        },
                      ));
                    },
                    child: Text('Forgot Password?',
                        style: TextStyle(
                            color: Colors.grey[600], fontFamily: 'Outfit')),
                  ),
                ],
              ),

              SizedBox(height: 25),

              //! Login Button
              GestureDetector(
                onTap: () => login(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(143, 173, 222, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 50),

              //! Or continue with google
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or',
                        style: TextStyle(
                            color: Colors.grey[700], fontFamily: 'Outfit'),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              //! Google
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => AuthService().signInWithGoogle(),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 60),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: Row(
                        children: [
                          Image.asset('image/Google.png', height: 20),
                          Text('Continue with Google',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Outfit')),
                        ],
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 40),

              //! don't have an account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style:
                        TextStyle(color: Colors.grey[700], fontFamily: 'Outfit'),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.showSignUpPage,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.grey[700],
                        decoration: TextDecoration.underline,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ),
                ],
              )
            ]),
          ],
        ),
      )),
    );
  }
}
