import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uni_talk/models/virtual_user.dart';
import 'package:uni_talk/services/virtual_user_service.dart';

class VirtualUserProvider with ChangeNotifier {
  final VirtualUserService _virtualUserService = VirtualUserService();

  // Get Users query
  CollectionReference<VirtualUser> getVirtualUserReferences() {
    return _virtualUserService.getVirtualUserReferences();
  }

  Future<int> getTotalUsersCount() async {
    return _virtualUserService.getTotalUsersCount();
  }

  Future<VirtualUser?> getVirtualUser(String virtualUserId) async {
    return _virtualUserService.getVirtualUser(virtualUserId);
  }

  // Future<List<VirtualUser>> getVirtualUsers() async {
  //   return _virtualUserService.getVirtualUsers();
  // }

  // Future<List<VirtualUser>> getTopFollowerVirtualUsers() async {
  //   return _virtualUserService.getTopFollowerVirtualUsers();
  // }

  Future<void> addFollowers(String id) async {
    await _virtualUserService.addFollowers(id);
    notifyListeners();
  }
}
