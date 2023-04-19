import 'package:flutter/foundation.dart';
import 'package:uni_talk/models/virtual_user.dart';
import 'package:uni_talk/services/virtual_user_service.dart';

class VirtualUserProvider with ChangeNotifier {
  final VirtualUserService _virtualUserService = VirtualUserService();

  Future<VirtualUser?> getVirtualUser(String id) async {
    return _virtualUserService.getVirtualUser(id);
  }

  Future<List<VirtualUser>> getVirtualUsers() async {
    return _virtualUserService.getVirtualUsers();
  }

  Future<List<VirtualUser>> getTopFollowerVirtualUsers() async {
    return _virtualUserService.getTopFollowerVirtualUsers();
  }

  Future<void> addFollowers(String id) async {
    await _virtualUserService.addFollowers(id);
    notifyListeners();
  }
}
