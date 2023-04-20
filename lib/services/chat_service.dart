import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_talk/config/chat.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/models/chat_room.dart';

class ChatService {
  final chatRoomRef = FirebaseFirestore.instance.collection('chat_rooms');
  final chatMessageRef = FirebaseFirestore.instance.collection('chat_messages');

  Future<ChatRoom?> getExistingChatRoom(String userId,
      {String? virtualUserId}) async {
    Query query = chatRoomRef.where('userId', isEqualTo: userId);

    if (virtualUserId != null) {
      query = query.where('virtualUserId', isEqualTo: virtualUserId);
    }

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      return ChatRoom.fromDocumentSnapshot(querySnapshot.docs.first);
    } else {
      return null;
    }
  }

  // 채팅룸 생성
  Future<ChatRoom> createChatRoom(ChatRoom chatRoom) async {
    final docRef = await chatRoomRef.add({
      'userId': chatRoom.userId,
      'title': chatRoom.title,
      'image': chatRoom.image,
      'type': getChatRoomType(chatRoom.type),
      'previewMessage': null,
      'virtualUserId': chatRoom.virtualUserId,
      'createTime': DateTime.now(),
      'modifiedTime': DateTime.now(),
    });

    final newChatRoom = ChatRoom(
        id: docRef.id,
        userId: chatRoom.userId,
        title: chatRoom.title,
        image: chatRoom.image,
        type: chatRoom.type,
        previewMessage: null,
        virtualUserId: chatRoom.virtualUserId);

    return newChatRoom;
  }

// 채팅룸 목록(마지막 메시지를 포함)을 가져오기
  Stream<QuerySnapshot> streamChatRooms({
    required String userId,
    String? title,
    String? type,
    String? category,
  }) {
    return chatRoomRef
        .where('userId', isEqualTo: userId)
        .orderBy('modifiedTime', descending: true)
        .snapshots();
  }

  // 메시지 스트림
  Stream<QuerySnapshot> streamChatMessages(String chatRoomId) {
    return chatMessageRef
        .where('chatRoomId', isEqualTo: chatRoomId)
        .orderBy('createTime')
        .snapshots();
  }

  // 메시지 전송
  Future<void> sendMessage(ChatMessage chatMessage) async {
    await chatMessageRef.add({
      'chatRoomId': chatMessage.chatRoomId,
      'sentBy': getMessageSender(chatMessage.sentBy),
      'message': chatMessage.message,
      'like': chatMessage.like,
      'createTime': DateTime.now(),
    });
    await updateChatRoomPreview(chatMessage.chatRoomId, chatMessage.message);
  }

  // 메시지 업데이트
  Future<void> updateMessage(
      String messageId, ChatMessage updatedChatMessage) async {
    await chatMessageRef.doc(messageId).update({
      'chatRoomId': updatedChatMessage.chatRoomId,
      'sentBy': getMessageSender(updatedChatMessage.sentBy),
      'message': updatedChatMessage.message,
      'like': updatedChatMessage.like,
    });
    await updateChatRoomPreview(
        updatedChatMessage.chatRoomId, updatedChatMessage.message);
  }

  // 채팅룸의 modifiedTime과 previewMessage 업데이트
  Future<void> updateChatRoomPreview(
      String chatRoomId, String previewMessage) async {
    String shortenedPreviewMessage = previewMessage;

    if (previewMessage.length > 30) {
      shortenedPreviewMessage = previewMessage.substring(0, 30);
    }
    await chatRoomRef.doc(chatRoomId).update({
      'previewMessage': shortenedPreviewMessage,
      'modifiedTime': DateTime.now(),
    });
  }
}
