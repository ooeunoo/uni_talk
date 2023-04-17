import 'package:cloud_firestore/cloud_firestore.dart';

class RoleChat {
  final String? id;
  final String category;
  final String role;
  final bool type;
  final String systemMessage;
  final String welcomeMessage;
  final List<String> questions;
  final String image;
  final int selected;
  final Timestamp createTime;
  final Timestamp modifiedTime;

  RoleChat({
    this.id,
    required this.category,
    required this.role,
    required this.systemMessage,
    required this.welcomeMessage,
    required this.questions,
    required this.type,
    required this.image,
    required this.selected,
    required this.createTime,
    required this.modifiedTime,
  });

  factory RoleChat.fromMap(Map<String, dynamic> map) {
    return RoleChat(
      id: map['id'],
      category: map['category'],
      role: map['role'],
      type: map['type'],
      systemMessage: map['systemMessage'],
      welcomeMessage: map['welcomeMessage'],
      questions: List<String>.from(map['questions']),
      image: map['image'],
      selected: map['selected'],
      createTime: map['createTime'],
      modifiedTime: map['modifiedTime'],
    );
  }

  @override
  String toString() {
    return 'RoleChat(id: $id, category: $category, role: $role, type: $type, systemMessage: $systemMessage, welcomeMessage: $welcomeMessage, questions: $questions, image: $image, selected: $selected, createTime: $createTime, modifiedTime: $modifiedTime)';
  }
}
