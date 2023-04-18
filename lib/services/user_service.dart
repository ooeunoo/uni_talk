import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as Kakao;
import 'package:uni_talk/config/auth_provider.dart';
import 'package:http/http.dart' as http;

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  Future<bool> isUserRegistered(String uid) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(uid).get();
    return snapshot.exists;
  }

  Future<void> addUserToFirestore(
      User user, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(user.uid).set(userData);
  }

  // Add a new method to save the user information if not already saved
  Future<void> signInAndSaveUser(AuthProvider platform,
      {String? email, String? password}) async {
    User? user = await signIn(platform, email: email, password: password);
    if (user != null) {
      bool isRegistered = await isUserRegistered(user.uid);
      if (!isRegistered) {
        String provider = getCurrentProvider();

        Map<String, dynamic> userData = {
          'id': user.uid,
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
          'phoneNumber': user.phoneNumber,
          'provider': provider,
        };
        await addUserToFirestore(user, userData);
      }
    }
  }

  Future<User?> signIn(AuthProvider platform,
      {String? email, String? password}) async {
    switch (platform) {
      case AuthProvider.local:
        return signInWithLocal(email: email!, password: password!);
      case AuthProvider.google:
        return signInWithGoogle();
      case AuthProvider.kakao:
        return signInWithKakao();
      case AuthProvider.apple:
        return signInWithApple();
      default:
        return null;
    }
  }

  Future<User?> signInWithCredential(AuthCredential credential) async {
    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  Future<User?> signUpWithLocal(
      {required String email, required String password}) async {
    final UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<User?> signInWithLocal(
      {required String email, required String password}) async {
    final UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
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
    late Kakao.OAuthToken token;

    if (await Kakao.isKakaoTalkInstalled()) {
      try {
        // 카카오 앱 로그인
        token = await Kakao.UserApi.instance.loginWithKakaoTalk();
      } catch (e) {
        print(e);

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (e is PlatformException && e.code == 'CANCELED') {
          return null;
        }
        try {
          // 카카오 계정 로그인
          token = await Kakao.UserApi.instance.loginWithKakaoAccount();
        } catch (e) {
          print(e);
          return null;
        }
      }
    } else {
      // 카카오 계정 로그인
      try {
        token = await Kakao.UserApi.instance.loginWithKakaoAccount();
      } catch (e) {
        print(e);

        return null;
      }
    }

    Kakao.User kakaoUser = await Kakao.UserApi.instance.me();

    String kakaoCustomToken = await _getKakaoCustomTokenFromCloudFunctions({
      'uid': kakaoUser.id.toString(),
      'displayName': kakaoUser.kakaoAccount?.profile?.nickname,
      'email': kakaoUser.kakaoAccount?.email!,
      'photoURL': kakaoUser.kakaoAccount?.profile?.profileImageUrl
    });

    final UserCredential userCredential =
        await _auth.signInWithCustomToken(kakaoCustomToken);

    return userCredential.user;
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
      return null;
    }
  }

  Future<void> signOut() async {
    if (_auth.currentUser != null) {
      // 로그아웃 시 사용자가 어떤 서비스로 로그인했는지 확인하고 로그아웃 처리를 추가합니다.
      final provider = getCurrentProvider();
      switch (provider) {
        case 'google':
          await _googleSignIn.signOut();
          break;
        case 'kakao':
          await Kakao.UserApi.instance.logout();
          break;
        case 'apple':
          // Apple 로그아웃에 대한 명시적인 API는 없습니다.
          break;
      }
    }
    await _auth.signOut();
  }

  String getCurrentProvider() {
    String provider = currentUser!.providerData.isEmpty
        ? currentUser!.uid.split(':')[0]
        : currentUser!.providerData[0].providerId.replaceFirst('.com', '');
    return provider;
  }

// 휴대폰 인증 코드 전송
  // Future<Map<String, dynamic>> sendVerificationCode(String phoneNumber) async {
  //   bool isSent = false;
  //   String? savedVerificationId;

  //   await _auth.verifyPhoneNumber(
  //     phoneNumber: phoneNumber,
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       // This callback is called when the verification is done automatically without user input
  //       await _auth.signInWithCredential(credential);
  //       isSent = true;
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       // Handle the error when the verification fails
  //       print(e);
  //       isSent = false;
  //     },
  //     codeSent: (String verificationId, int? resendToken) {
  //       savedVerificationId = verificationId;
  //       isSent = true;
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //       // Handle the timeout
  //     },
  //   );

  //   return {
  //     'isSent': isSent,
  //     'verificationId': savedVerificationId,
  //   };
  // }
}
