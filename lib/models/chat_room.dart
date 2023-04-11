import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_talk/config/chat/category.dart';
import 'package:uni_talk/config/chat/type.dart';
import 'package:uni_talk/models/chat_message.dart';

class ChatRoom {
  final String id;
  final String userId;
  final String title;
  final String? image;
  final ChatRoomType type;
  final ChatRoomCategory category;
  final Timestamp? createTime;

  ChatRoom({
    required this.id,
    required this.userId,
    required this.title,
    this.image,
    required this.type,
    required this.category,
    this.createTime,
  });

  factory ChatRoom.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final id = doc.id;
    final userId = data['userId'];
    final title = data['title'];
    final image = data['image'];
    final type = getChatRoomTypeByString(data['type']);
    final category = getChatRoomCategoryByString(data['type']);
    final createTime = data['createTime'];

    return ChatRoom(
        id: id,
        userId: userId,
        title: title,
        image: image,
        type: type,
        category: category,
        createTime: createTime);
  }
}

class ChatRoomWithLastMessage {
  final ChatRoom chatRoom;
  final ChatMessage? lastMessage;

  ChatRoomWithLastMessage({required this.chatRoom, this.lastMessage});
}
