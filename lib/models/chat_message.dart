import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_talk/config/chat.dart';

class ChatMessage {
  final String? id;
  final String chatRoomId;
  final MessageSender sentBy;
  final String message;
  final bool like;
  final Timestamp? createTime;

  ChatMessage({
    this.id,
    required this.chatRoomId,
    required this.sentBy,
    required this.message,
    required this.like,
    this.createTime,
  });

  factory ChatMessage.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ChatMessage(
        id: doc.id,
        chatRoomId: data['chatRoomId'],
        sentBy: getMessageSenderByString(data['sentBy']),
        message: data['message'],
        like: data['like'],
        createTime: data['createTime']);
  }

  ChatMessage copyWith({
    String? chatRoomId,
    String? message,
    MessageSender? sentBy,
    bool? like,
  }) {
    return ChatMessage(
      chatRoomId: chatRoomId ?? this.chatRoomId,
      message: message ?? this.message,
      sentBy: sentBy ?? this.sentBy,
      like: like ?? this.like,
    );
  }
}
