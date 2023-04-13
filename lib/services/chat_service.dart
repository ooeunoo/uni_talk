import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_talk/config/chat/category.dart';
import 'package:uni_talk/config/chat/message_sender.dart';
import 'package:uni_talk/config/chat/type.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/models/chat_room.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 채팅룸 생성
  Future<void> createChatRoom(ChatRoom chatRoom) async {
    await _firestore.collection('chat_rooms').add({
      'userId': chatRoom.userId,
      'title': chatRoom.title,
      'image': chatRoom.image,
      'type': getChatRoomType(chatRoom.type),
      'category': getChatRoomCategory(chatRoom.category),
      'createTime': DateTime.now()
    });
  }

// 채팅룸 목록(마지막 메시지를 포함)을 가져오기
  Stream<List<ChatRoomWithLastMessage>> getChatRoomsByUserId({
    required String userId,
    String? title,
    String? type,
    String? category,
    bool ascending = true,
  }) {
    Query query =
        _firestore.collection('chat_rooms').where('userId', isEqualTo: userId);

    if (type != null && type.isNotEmpty) {
      query = query.where('type', isEqualTo: type);
    }

    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }

    query = query.orderBy('createTime', descending: !ascending);

    return query.snapshots().asyncMap((querySnapshot) async {
      List<ChatRoomWithLastMessage> chatRoomWithLastMessages = [];

      for (var chatRoomDoc in querySnapshot.docs) {
        ChatRoom chatRoom = ChatRoom.fromDocumentSnapshot(chatRoomDoc);

        QuerySnapshot lastMessageSnapshot = await FirebaseFirestore.instance
            .collection('chat_messages')
            .where('chatRoomId', isEqualTo: chatRoom.id)
            .orderBy('createTime', descending: true)
            .limit(1)
            .get();

        ChatMessage? lastMessage;
        if (lastMessageSnapshot.docs.isNotEmpty) {
          lastMessage =
              ChatMessage.fromDocumentSnapshot(lastMessageSnapshot.docs.first);
        }

        chatRoomWithLastMessages.add(ChatRoomWithLastMessage(
            chatRoom: chatRoom, lastMessage: lastMessage));
      }

      return chatRoomWithLastMessages;
    });
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
      'createTime': DateTime.now(),
    });
  }
}
