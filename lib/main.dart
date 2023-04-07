import 'package:flutter/material.dart';
import 'package:uni_talk/config/theme.dart';
import 'package:uni_talk/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options = DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData getThemeData(Brightness brightness) {
    return brightness == Brightness.light
        ? lightThemeData.themeData
        : darkThemeData.themeData;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      // debugShowMaterialGrid: true,
      title: 'Flutter Splash Screen Demo',
      theme: getThemeData(Brightness.light),
      darkTheme: getThemeData(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
