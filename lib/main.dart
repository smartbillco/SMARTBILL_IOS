import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbill/screens/splash/splash.dart';
import 'package:smartbill/services/auth.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:smartbill/services/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize timezone data
  await FlutterDownloader.initialize();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
          StreamProvider.value(value: AuthService().user, initialData: null, child: const MyApp()),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      title: 'Smartbill',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true, 
      ),
    );
  }
}

