import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_talk/config/chat.dart';

class ChatRoom {
  final String? id;
  final String userId;
  final String title;
  final ChatRoomType type;
  final String? image;
  final String? virtualUserId;
  final String? previewMessage;
  final Timestamp? createTime;
  final Timestamp? modifiedTime;

  ChatRoom(
      {this.id,
      required this.userId,
      required this.title,
      required this.type,
      this.image,
      this.virtualUserId,
      this.previewMessage,
      this.createTime,
      this.modifiedTime});

  factory ChatRoom.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final id = doc.id;
    final userId = data['userId'];
    final title = data['title'];
    final type = getChatRoomTypeByString(data['type']);
    final image = data['image'];
    final virtualUserId = data['virtualUserId'];
    final previewMessage = data['previewMessage'];
    final createTime = data['createTime'];
    final modifiedTime = data['modifiedTime'];

    return ChatRoom(
        id: id,
        userId: userId,
        title: title,
        image: image,
        type: type,
        previewMessage: previewMessage,
        virtualUserId: virtualUserId,
        createTime: createTime,
        modifiedTime: modifiedTime);
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      type: getChatRoomTypeByString(json['type']),
      image: json['image'],
      virtualUserId: json['virtualUserId'],
      previewMessage: json['previewMessage'],
      createTime: json['createTime'],
      modifiedTime: json['modifiedTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'type': type.toString(),
      'image': image,
      'virtualUserId': virtualUserId,
      'previewMessage': previewMessage,
      'createTime': createTime,
      'modifiedTime': modifiedTime,
    };
  }

  ChatRoom copyWith(
    Map<String, Object?> map, {
    String? userId,
    String? title,
    ChatRoomType? type,
    String? image,
    String? virtualUserId,
    String? previewMessage,
    Timestamp? createTime,
    Timestamp? modifiedTime,
  }) {
    return ChatRoom(
      userId: userId ?? this.userId,
      title: title ?? this.title,
      type: type ?? this.type,
      image: image ?? this.image,
      virtualUserId: virtualUserId ?? this.virtualUserId,
      previewMessage: previewMessage ?? this.previewMessage,
      createTime: createTime ?? this.createTime,
      modifiedTime: modifiedTime ?? this.modifiedTime,
    );
  }
}
