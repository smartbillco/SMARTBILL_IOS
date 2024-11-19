import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () => Navigator.of(context).pushReplacementNamed('/home'));

    return const Scaffold(
   
        body: Center(
          child: Image(image: AssetImage("assets/images/empresa.png")),
  
      ),
    );
  }
}