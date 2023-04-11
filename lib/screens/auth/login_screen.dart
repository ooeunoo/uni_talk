import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_talk/config/auth_provider.dart';
import 'package:uni_talk/providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _handleLogin(AuthProvider platform) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.signIn(platform);
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
                    await _handleLogin(AuthProvider.kakao);
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
                    await _handleLogin(AuthProvider.apple);
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
                      await _handleLogin(AuthProvider.google);
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
