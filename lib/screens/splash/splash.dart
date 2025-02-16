import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartbill/screens/wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
          child: AnimatedSplashScreen(
            duration: 3000,
            nextScreen: const Wrapper(),
            splashTransition: SplashTransition.fadeTransition,
            splashIconSize: 180,
            splash: SvgPicture.asset(
              'assets/images/sm_olive_green.svg',
              width: 150,           // Set width and height as needed
              height: 150,
              semanticsLabel: 'SVG Image', 
            ),
          ),
        )
    );
  }
}

