import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_talk/config/theme.dart';
import 'package:uni_talk/providers/chat_provider.dart';
import 'package:uni_talk/providers/storage_box_provider.dart';
import 'package:uni_talk/providers/user_provider.dart';
import 'package:uni_talk/providers/virtual_user_provider.dart';
import 'package:uni_talk/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  kakao.KakaoSdk.init(nativeAppKey: '8ba036327e5a77b12fd518bec094e0ec');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => VirtualUserProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => StorageBoxProvider())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: true,
          // debugShowMaterialGrid: true,
          title: 'Flutter Splash Screen Demo',
          theme: getThemeData(Brightness.light).themeData,
          // darkTheme: getThemeData(Brightness.dark).themeData,
          themeMode: ThemeMode.system,
          home: const SplashScreen()),
    );
  }
}
