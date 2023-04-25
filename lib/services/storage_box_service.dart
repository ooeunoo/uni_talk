import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_talk/models/storage_box.dart';

class StorageBoxService {
  final storageBoxRef = FirebaseFirestore.instance.collection('storage_boxes');
  final storageItemRef = FirebaseFirestore.instance.collection('storage_items');

  Future<StorageBox?> getStorageBox(
    String userId,
  ) async {
    Query query = storageBoxRef.where('userId', isEqualTo: userId);

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      return StorageBox.fromDocumentSnapshot(querySnapshot.docs.first);
    } else {
      return null;
    }
  }

  Query<StorageBox> getStorageBoxReferences(String userId) {
    return storageBoxRef
        .where('userId', isEqualTo: userId)
        .orderBy('createTime', descending: true)
        .withConverter<StorageBox>(
            fromFirestore: (snapshot, _) =>
                StorageBox.fromDocumentSnapshot(snapshot),
            toFirestore: (storageBox, _) => storageBox.toJson());
  }

  // 스토리지 박스 생성
  Future<StorageBox> createStorageBox(StorageBox storageBox) async {
    final docRef = await storageBoxRef.add({
      'userId': storageBox.userId,
      'title': storageBox.title,
      'icon': storageBox.icon,
      'totalItems': storageBox.totalItems,
      'createTime': DateTime.now(),
      'modifiedTime': DateTime.now(),
    });

    final newStorageBox = StorageBox(
      id: docRef.id,
      userId: storageBox.userId,
      title: storageBox.title,
      totalItems: storageBox.totalItems + 1,
      icon: storageBox.icon,
    );

    return newStorageBox;
  }

  // 스토리지 박스 아이템 저장
  Future<void> saveStorageItem(
      String storageBoxId, StorageItem storageItem) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // Add the new storage item
      await storageItemRef.add({
        'storageBoxId': storageBoxId,
        'data': storageItem.data,
        'createTime': DateTime.now(),
        'modifiedTiem': DateTime.now(),
      });

      // Update the totalItems count of the storage box
      final storageBoxIdRef = storageBoxRef.doc(storageBoxId);
      final storageBoxSnapshot = await transaction.get(storageBoxIdRef);
      final storageBoxData = storageBoxSnapshot.data();
      if (storageBoxData == null) {
        return;
      }
      final int totalItems = storageBoxData['totalItems'] ?? 0;
      final int newTotalItems = totalItems + 1;
      transaction.update(storageBoxIdRef, {
        'modifiedTime': DateTime.now(),
        'totalItems': newTotalItems,
      });
    });
  }
}
