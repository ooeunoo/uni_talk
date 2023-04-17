import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_talk/config/chat/category.dart';
import 'package:uni_talk/config/chat/message_sender.dart';
import 'package:uni_talk/config/chat/type.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/models/chat_room.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ChatRoom?> getExistingChatRoom(
      String userId, String roleChatId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('chat_rooms')
        .where('userId', isEqualTo: userId)
        .where('roleChatId', isEqualTo: roleChatId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return ChatRoom.fromDocumentSnapshot(querySnapshot.docs.first);
    } else {
      return null;
    }
  }

  // 채팅룸 생성
  Future<ChatRoom> createChatRoom(ChatRoom chatRoom) async {
    final docRef = await _firestore.collection('chat_rooms').add({
      'userId': chatRoom.userId,
      'roleChatId': chatRoom.roleChatId,
      'title': chatRoom.title,
      'image': chatRoom.image,
      'type': getChatRoomType(chatRoom.type),
      'category': getChatRoomCategory(chatRoom.category),
      'previewMessage': null,
      'createTime': DateTime.now(),
      'modifiedTime': DateTime.now(),
    });

    final newChatRoom = ChatRoom(
      id: docRef.id,
      roleChatId: chatRoom.roleChatId,
      userId: chatRoom.userId,
      title: chatRoom.title,
      image: chatRoom.image,
      type: chatRoom.type,
      category: chatRoom.category,
      previewMessage: null,
    );

    return newChatRoom;
  }

// 채팅룸 목록(마지막 메시지를 포함)을 가져오기
  Stream<QuerySnapshot> streamChatRooms({
    required String userId,
    String? title,
    String? type,
    String? category,
  }) {
    return _firestore
        .collection('chat_rooms')
        .where('userId', isEqualTo: userId)
        .orderBy('modifiedTime', descending: true)
        .snapshots();
  }

  // 메시지 스트림
  Stream<QuerySnapshot> streamChatMessages(String chatRoomId) {
    return _firestore
        .collection('chat_messages')
        .where('chatRoomId', isEqualTo: chatRoomId)
        .orderBy('createTime')
        .snapshots();
  }

  // 메시지 전송
  Future<void> sendMessage(ChatMessage chatMessage) async {
    await _firestore.collection('chat_messages').add({
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
    await _firestore.collection('chat_messages').doc(messageId).update({
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
    await _firestore.collection('chat_rooms').doc(chatRoomId).update({
      'previewMessage': shortenedPreviewMessage,
      'modifiedTime': DateTime.now(),
    });
  }
}
