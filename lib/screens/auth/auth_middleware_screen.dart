import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uni_talk/screens/auth/login_screen.dart';
import 'package:uni_talk/screens/main_screen.dart';

class AuthMiddleWareScreen extends StatelessWidget {
  const AuthMiddleWareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          return user == null ? const LoginScreen() : const MainScreen();
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
