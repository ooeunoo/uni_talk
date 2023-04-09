import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as Kakao;
import 'package:uni_talk/config/auth_platform.dart';
import 'package:http/http.dart' as http;

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  Future<User?> signIn(AuthPlatform platform) async {
    switch (platform) {
      case AuthPlatform.Google:
        return signInWithGoogle();
      case AuthPlatform.Kakao:
        return signInWithKakao();
      case AuthPlatform.Apple:
        return signInWithApple();
      default:
        return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();
      if (googleAccount == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> signInWithKakao() async {
    try {
      late Kakao.OAuthToken token;

      if (await Kakao.isKakaoTalkInstalled()) {
        try {
          token = await Kakao.UserApi.instance.loginWithKakaoTalk();
          print('카카오톡으로 로그인 성공');
        } catch (error) {
          print('카카오톡으로 로그인 실패 $error');

          // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
          // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
          if (error is PlatformException && error.code == 'CANCELED') {
            return null;
          }
          // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
          try {
            token = await Kakao.UserApi.instance.loginWithKakaoAccount();
            print('카카오계정으로 로그인 성공');
          } catch (error) {
            print('카카오계정으로 로그인 실패 $error');
          }
        }
      } else {
        try {
          token = await Kakao.UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }

      Kakao.User kakaoUser = await Kakao.UserApi.instance.me();

      print({
        'uid': kakaoUser.id.toString(),
        'displayName': kakaoUser.kakaoAccount?.profile?.nickname,
        'email': kakaoUser.kakaoAccount?.email,
        'photoURL': kakaoUser.kakaoAccount?.profile?.profileImageUrl
      });

      String kakaoCustomToken = await _getKakaoCustomTokenFromCloudFunctions({
        'uid': kakaoUser.id.toString(),
        'displayName': kakaoUser.kakaoAccount?.profile?.nickname,
        'email': kakaoUser.kakaoAccount?.email ?? "",
        'photoURL': kakaoUser.kakaoAccount?.profile?.profileImageUrl
      });

      final UserCredential userCredential =
          await _auth.signInWithCustomToken(kakaoCustomToken);

      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> _getKakaoCustomTokenFromCloudFunctions(
      Map<String, dynamic?> user) async {
    final customTokenResponse = await http.post(
        Uri.parse(
            'https://us-central1-uni-talk-81f81.cloudfunctions.net/createKakaoCustomToken'),
        body: user);

    print(customTokenResponse.body);
    return customTokenResponse.body;
  }

  Future<User?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final AuthCredential oAuthCredential =
          OAuthProvider('apple.com').credential(
        accessToken: credential.authorizationCode,
        idToken: credential.identityToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(oAuthCredential);
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
