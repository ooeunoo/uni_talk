import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_talk/config/auth_platform.dart';
import 'package:uni_talk/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uni_talk/screens/auth/signup_screen.dart';
import 'package:uni_talk/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Map<String, dynamic>> _handleLogin(AuthPlatform platform) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    User? user = await userProvider.signIn(platform);

    if (user != null) {
      bool isRegistered =
          await userProvider.userService.isUserRegistered(user.uid);
      if (isRegistered) {
        return {"isRegistered": isRegistered, "user": user};
      }
    }
    return {"isRegistered": false, "user": user};
  }

  void _navigateToNextScreen(User? user, bool isRegistered) {
    if (user == null) return;

    if (isRegistered) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainScreen()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          // Container(
          //   width: screenSize.width,
          //   height: screenSize.height,
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage("assets/images/logo.png"),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () async {
                    Map<String, dynamic> result =
                        await _handleLogin(AuthPlatform.Kakao);

                    User? user = result['user'];
                    bool isRegistered = result['isRegistered'];
                    _navigateToNextScreen(user, isRegistered);
                  },
                  child: Image.asset(
                    'assets/images/social/kakao_login_button.png',
                    width: screenSize.width * 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () async {
                    Map<String, dynamic> result =
                        await _handleLogin(AuthPlatform.Apple);

                    User? user = result['user'];
                    bool isRegistered = result['isRegistered'];
                    _navigateToNextScreen(user, isRegistered);
                  },
                  child: Image.asset(
                    'assets/images/social/apple_login_button.png',
                    width: screenSize.width * 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                    onTap: () async {
                      Map<String, dynamic> result =
                          await _handleLogin(AuthPlatform.Google);

                      User? user = result['user'];
                      bool isRegistered = result['isRegistered'];
                      _navigateToNextScreen(user, isRegistered);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: Colors.grey, width: 0.3)),
                      child: Image.asset(
                        'assets/images/social/google_login_button.png',
                        width: screenSize.width * 0.8,
                      ),
                    )),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => _showLoginOptions(),
                child: const Text(
                  '다른 방법으로 시작하기',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
            ],
          ),
        ],
      ),
    );
  }

  _showLoginOptions() {
    final screenSize = MediaQuery.of(context).size;

    _scaffoldKey.currentState?.showBottomSheet<void>((BuildContext context) {
      return Container(
        height: screenSize.height * 0.2,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            TextButton(
              onPressed: () {},
              child: const Text('이메일로 시작하기'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('페이스북으로 시작하기'),
            ),
          ],
        ),
      );
    });
  }
}
