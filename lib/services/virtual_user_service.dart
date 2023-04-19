import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_talk/models/virtual_user.dart';

class VirtualUserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<VirtualUser?> getVirtualUser(String id) async {
    final roleChatSnapshot =
        await _firestore.collection('virtual_users').doc(id).get();

    if (roleChatSnapshot.exists) {
      final data = roleChatSnapshot.data() as Map<String, dynamic>;
      data['id'] = roleChatSnapshot.id;
      return VirtualUser.fromMap(data);
    } else {
      return null;
    }
  }

  Future<List<VirtualUser>> getVirtualUsers() async {
    Query query = _firestore.collection('virtual_users');

    // query = query.orderBy('modifiedTime', descending: true);

    final virtualUsersSnapshot = await query.get();

    return virtualUsersSnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return VirtualUser.fromMap(data);
    }).toList();
  }

  Future<List<VirtualUser>> getTopFollowerVirtualUsers() async {
    final virtualUsersSnapshot = await _firestore
        .collection('virtual_users')
        .orderBy('followers', descending: true)
        .limit(5)
        .get();

    return virtualUsersSnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return VirtualUser.fromMap(data);
    }).toList();
  }

  Future<void> addFollowers(String id) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('virtual_users').doc(id).get();
    int followers = snapshot.get('followers');
    await _firestore.collection('virtual_users').doc(id).update({
      'followers': followers + 1,
    });
  }
}
