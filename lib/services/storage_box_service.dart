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
    await storageItemRef.add({
      'storageBoxId': storageBoxId,
      'data': storageItem.data,
      'createTime': DateTime.now(),
      'modifiedTiem': DateTime.now(),
    });
    await updateStorageBox(storageBoxId);
  }

  // // 메시지 업데이트
  // Future<void> updateMessage(
  //     String messageId, ChatMessage updatedChatMessage) async {
  //   await chatMessageRef.doc(messageId).update({
  //     'chatRoomId': updatedChatMessage.chatRoomId,
  //     'sentBy': getMessageSender(updatedChatMessage.sentBy),
  //     'message': updatedChatMessage.message,
  //     'like': updatedChatMessage.like,
  //   });
  //   await updateChatRoomPreview(
  //       updatedChatMessage.chatRoomId, updatedChatMessage.message);
  // }

  // 채팅룸의 modifiedTime과 previewMessage 업데이트
  Future<void> updateStorageBox(String storageBoxId) async {
    await storageBoxRef.doc(storageBoxId).update({
      'modifiedTime': DateTime.now(),
    });
  }
}
