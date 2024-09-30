// ignore_for_file: file_names

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:project/components/auth.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  get splash => null;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: LottieBuilder.asset('lottie/Animation - 1718429507707.json'),
      nextScreen: const AuthPage(),
      backgroundColor: const Color.fromRGBO(188, 215, 255, 1),
      splashIconSize: double.infinity,
      centered: true,
    );
  }
}
