import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_talk/models/virtual_user.dart';

class VirtualUserService {
  final virtualUserRef = FirebaseFirestore.instance.collection('virtual_users');

  CollectionReference<VirtualUser> getVirtualUserReferences() {
    return virtualUserRef.withConverter<VirtualUser>(
        fromFirestore: (snapshot, _) =>
            VirtualUser.fromDocumentSnapshot(snapshot),
        toFirestore: (virtualUser, _) => virtualUser.toJson());
  }

  Future<int> getTotalUsersCount() async {
    final snapshot = await virtualUserRef.get();
    return snapshot.docs.length;
  }

  Future<VirtualUser?> getVirtualUser(String virtualUserId) async {
    try {
      final snapshot = await virtualUserRef.doc(virtualUserId).get();
      if (!snapshot.exists) {
        return null;
      }
      return VirtualUser.fromDocumentSnapshot(snapshot);
    } catch (e) {
      print('Error getting virtual user: $e');
      return null;
    }
  }

  // Future<VirtualUser?> getVirtualUser(String virtualUserId) async {
  //   final roleChatSnapshot = await virtualUserRef.doc(virtualUserId).get();

  //   if (roleChatSnapshot.exists) {
  //     final data = roleChatSnapshot.data() as Map<String, dynamic>;
  //     data['id'] = roleChatSnapshot.id;
  //     // return VirtualUser.fromJson(data);
  //   } else {
  //     return null;
  //   }
  // }

  // Future<List<VirtualUser>> getVirtualUsers() async {
  //   Query query = virtualUserRef;

  //   final virtualUsersSnapshot = await query.get();

  //   return virtualUsersSnapshot.docs.map((doc) {
  //     final data = doc.data() as Map<String, dynamic>;
  //     data['id'] = doc.id;
  //     return VirtualUser.fromJson(data);
  //   }).toList();
  // }

  // Future<List<VirtualUser>> getTopFollowerVirtualUsers() async {
  //   final virtualUsersSnapshot = await virtualUserRef
  //       .orderBy('followers', descending: true)
  //       .limit(5)
  //       .get();

  //   return virtualUsersSnapshot.docs.map((doc) {
  //     final data = doc.data();
  //     data['id'] = doc.id;
  //     return VirtualUser.fromJson(data);
  //   }).toList();
  // }

  Future<void> addFollowers(String virtualUserId) async {
    DocumentSnapshot snapshot = await virtualUserRef.doc(virtualUserId).get();
    int followers = snapshot.get('followers');
    await virtualUserRef.doc(virtualUserId).update({
      'followers': followers + 1,
    });
  }
}
