import 'package:flutter/material.dart';
import 'package:smartbill/views/home/home_screen.dart';
import 'package:smartbill/views/login/login_screen.dart';
import 'package:smartbill/views/splash/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen()
      },
      title: 'Smartbill',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white38),
        useMaterial3: true,
      ),
    );
  }
}

