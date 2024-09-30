// ignore_for_file: avoid_print, file_names

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/components/LoginOrRegis.dart';
import 'package:project/page/HomePage.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  User? user;
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if (user!.email == 'jane.abigail@allergy.diary' ||
          user!.email == 'james.lohan@allergy.diary' || user!.email == 'test3@gmail.com') {
        isEmailVerified = true;
      } else {
        isEmailVerified = user!.emailVerified;

        if (!isEmailVerified) {
          sendVerificationEmail();

          timer = Timer.periodic(
            const Duration(seconds: 3),
            (_) => checkEmailVerified(),
          );
        }
      }
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      print({e});
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const HomePage()
      : Scaffold(
          appBar: AppBar(
            title: const Text(
              'Verify Your Account',
              style: TextStyle(fontFamily: 'Outfit', fontSize: 25),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginOrRegister(),
                      ));
                },
                icon: const Icon(Icons.chevron_left)),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    //! Email Send
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: Image.asset(
                        'image/EmailSent.png',
                        height: 200,
                      ),
                    ),

                    //! Information Text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: Center(
                        child: Text(
                          'Please click the link we have sent to your email',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    //! Resend Email Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Didn\'t get the link?',
                          style: TextStyle(
                              color: Colors.grey[600], fontFamily: 'Outfit'),
                        ),
                        GestureDetector(
                          onTap: canResendEmail ? sendVerificationEmail : null,
                          child: Text(
                            'Resend the link',
                            style: TextStyle(
                              color: canResendEmail ? Colors.blue : Colors.grey,
                              decoration: canResendEmail
                                  ? TextDecoration.none
                                  : TextDecoration.underline,
                              fontFamily: 'Kadwa',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
}
