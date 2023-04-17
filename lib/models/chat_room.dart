import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_talk/config/chat/category.dart';
import 'package:uni_talk/config/chat/type.dart';

class ChatRoom {
  final String? id;
  final String userId;
  final String title;
  final String? image;
  final ChatRoomType type;
  final ChatRoomCategory category;
  final String? roleChatId;
  final String? previewMessage;
  final Timestamp? createTime;
  final Timestamp? modifiedTime;

  ChatRoom(
      {this.id,
      required this.userId,
      required this.title,
      this.image,
      required this.type,
      required this.category,
      this.roleChatId,
      this.previewMessage,
      this.createTime,
      this.modifiedTime});

  factory ChatRoom.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final id = doc.id;
    final userId = data['userId'];
    final roleChatId = data['roleChatId'];
    final title = data['title'];
    final image = data['image'];
    final type = getChatRoomTypeByString(data['type']);
    final category = getChatRoomCategoryByString(data['type']);
    final previewMessage = data['previewMessage'];
    final createTime = data['createTime'];
    final modifiedTime = data['modifiedTime'];

    return ChatRoom(
        id: id,
        userId: userId,
        roleChatId: roleChatId,
        title: title,
        image: image,
        type: type,
        category: category,
        previewMessage: previewMessage,
        createTime: createTime,
        modifiedTime: modifiedTime);
  }
}
