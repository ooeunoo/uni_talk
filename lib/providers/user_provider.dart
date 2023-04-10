import 'package:flutter/cupertino.dart';
import 'package:uni_talk/config/auth_platform.dart';
import 'package:uni_talk/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();

  User? get currentUser => _userService.currentUser;

  UserService get userService => _userService;

  Future<User?> signIn(AuthPlatform platform,
      {String? email, String? password}) async {
    User? user =
        await _userService.signIn(platform, email: email, password: password);
    notifyListeners();
    return user;
  }

  Future<void> signOut() async {
    await _userService.signOut();
    notifyListeners();
  }
}
