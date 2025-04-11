import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:smartbill/screens/splash/splash.dart';
import 'package:smartbill/services/auth.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:smartbill/services/settings.dart';
import 'package:timezone/data/latest_all.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Hace la barra de estado transparente
    systemNavigationBarColor: Colors.transparent, // Hace la barra de navegación transparente
    systemNavigationBarContrastEnforced: false,
  ));
  // Initialize timezone data
  tz.initializeTimeZones();
  await FlutterDownloader.initialize();
  await Firebase.initializeApp();
  _initNotifications();
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

Future<void> _initNotifications() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/logo');
  const initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
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

