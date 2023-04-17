import 'package:flutter/foundation.dart';
import 'package:uni_talk/config/role_chat_category.dart';
import 'package:uni_talk/models/role_chat.dart';
import 'package:uni_talk/services/role_chat_service.dart';

class RoleChatProvider with ChangeNotifier {
  final RoleChatService _roleChatService = RoleChatService();

  Future<RoleChat?> getRoleChat(String id) async {
    return _roleChatService.getRoleChat(id);
  }

  Future<List<RoleChat>> getRoleChats({RoleChatCategory? category}) async {
    return _roleChatService.getRoleChats(category: category);
  }

  Future<List<RoleChat>> getTopSelectedRoleChats() async {
    return _roleChatService.getTopSelectedRoleChats();
  }

  Future<void> upSelectedRoleChat(String id) async {
    await _roleChatService.upSelectedRoleChat(id);
    notifyListeners();
  }
}
