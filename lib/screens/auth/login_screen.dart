import 'package:flutter/material.dart';
import 'package:uni_talk/config/auth_platform.dart';
import 'package:uni_talk/services/user_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Login Screen')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSignInButton(
                'Sign in with Google',
                AuthPlatform.Google,
                Colors.blue,
              ),
              const SizedBox(height: 20),
              _buildSignInButton(
                'Sign in with Kakao',
                AuthPlatform.Kakao,
                Colors.yellow,
              ),
              const SizedBox(height: 20),
              _buildSignInButton(
                'Sign in with Apple',
                AuthPlatform.Apple,
                Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(
      String buttonText, AuthPlatform platform, Color buttonColor) {
    return OutlinedButton(
      onPressed: () async {
        final userService = UserService();
        final user = await userService.signIn(platform);
        if (user != null) {
          print('User signed in: ${user.displayName}');
        } else {
          print('Sign in failed');
        }
      },
      child: Text(
        buttonText,
        style: TextStyle(color: buttonColor),
      ),
    );
  }
}
