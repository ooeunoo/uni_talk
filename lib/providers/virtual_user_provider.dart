import 'package:flutter/foundation.dart';
import 'package:uni_talk/models/virtual_user.dart';
import 'package:uni_talk/services/virtual_user_service.dart';

class VirtualUserProvider with ChangeNotifier {
  final VirtualUserService _virtualUserService = VirtualUserService();

  Stream<List<VirtualUser>> getUsers({required int limit}) {
    return _virtualUserService.getUsers(limit: limit);
  }

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
