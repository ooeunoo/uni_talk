import 'package:flutter/cupertino.dart';
import 'package:uni_talk/config/auth_provider.dart';
import 'package:uni_talk/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();

  User? get currentUser => _userService.currentUser;

  UserService get userService => _userService;

  Future<void> signIn(AuthProvider platform,
      {String? email, String? password}) async {
    await _userService.signInAndSaveUser(platform,
        email: email, password: password);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _userService.signOut();
    notifyListeners();
  }
}
