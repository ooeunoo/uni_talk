import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_talk/config/chat/message_sender.dart';

class ChatMessage {
  final String? id;
  final String chatRoomId;
  final MessageSender sentBy;
  final String message;
  final Timestamp? createTime;

  ChatMessage({
    this.id,
    required this.chatRoomId,
    required this.sentBy,
    required this.message,
    this.createTime,
  });

  factory ChatMessage.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final id = doc.id;
    final chatRoomId = data['chatRoomId'];
    final sentBy = getMessageSenderByString(data['sentBy']);
    final message = data['message'];
    final createTime = data['createTime'];

    return ChatMessage(
      id: id,
      chatRoomId: chatRoomId,
      sentBy: sentBy,
      message: message,
      createTime: createTime,
    );
  }
}
