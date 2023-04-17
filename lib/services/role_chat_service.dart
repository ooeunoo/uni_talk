import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_talk/config/role_chat_category.dart';
import 'package:uni_talk/models/role_chat.dart';

class RoleChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<RoleChat?> getRoleChat(String id) async {
    final roleChatSnapshot =
        await _firestore.collection('role_chats').doc(id).get();

    if (roleChatSnapshot.exists) {
      final data = roleChatSnapshot.data() as Map<String, dynamic>;
      data['id'] = roleChatSnapshot.id;
      return RoleChat.fromMap(data);
    } else {
      return null;
    }
  }

  Future<List<RoleChat>> getRoleChats({RoleChatCategory? category}) async {
    Query query = _firestore.collection('role_chats');

    if (category != null) {
      query = query.where('category', isEqualTo: getRoleChatCategory(category));
    }

    query = query.orderBy('modifiedTime', descending: true);

    final roleChatsSnapshot = await query.get();

    return roleChatsSnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return RoleChat.fromMap(data);
    }).toList();
  }

  Future<List<RoleChat>> getTopSelectedRoleChats() async {
    final roleChatsSnapshot = await _firestore
        .collection('role_chats')
        .orderBy('selected', descending: true)
        .limit(5)
        .get();

    return roleChatsSnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return RoleChat.fromMap(data);
    }).toList();
  }

  Future<void> upSelectedRoleChat(String id) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('role_chats').doc(id).get();
    int selected = snapshot.get('selected');
    await _firestore.collection('role_chats').doc(id).update({
      'selected': selected + 1,
    });
  }
}
