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

    return ChatRoom(
        id: doc.id,
        userId: data['userId'],
        title: data['title'],
        image: data['image'],
        type: getChatRoomTypeByString(data['type']),
        previewMessage: data['previewMessage'],
        virtualUserId: data['virtualUserId'],
        createTime: data['createTime'],
        modifiedTime: data['modifiedTime']);
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
