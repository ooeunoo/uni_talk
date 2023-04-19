import 'package:cloud_firestore/cloud_firestore.dart';

class VirtualUser {
  final String? id;
  final String name;
  final String job;
  final String profileId;
  final String profileImage;
  final String profileIntro;
  final String sex;
  final String systemMessage;
  final String welcomeMessage;
  final List<String> questions;
  final int followers;
  final int following;
  final Timestamp createTime;
  final Timestamp modifiedTime;

  VirtualUser({
    this.id,
    required this.name,
    required this.job,
    required this.profileId,
    required this.profileIntro,
    required this.profileImage,
    required this.sex,
    required this.systemMessage,
    required this.welcomeMessage,
    required this.questions,
    required this.followers,
    required this.following,
    required this.createTime,
    required this.modifiedTime,
  });

  factory VirtualUser.fromMap(Map<String, dynamic> map) {
    return VirtualUser(
      id: map['id'],
      name: map['name'],
      job: map['job'],
      profileId: map['profileId'],
      profileIntro: map['profileIntro'],
      profileImage: map['profileImage'],
      sex: map['sex'],
      systemMessage: map['systemMessage'],
      welcomeMessage: map['welcomeMessage'],
      questions: List<String>.from(map['questions']),
      followers: map['followers'],
      following: map['following'],
      createTime: map['createTime'],
      modifiedTime: map['modifiedTime'],
    );
  }

  @override
  String toString() {
    return 'VirtualUser(id: $id, name: $name, job: $job, profileId: $profileId, profileIntro: $profileIntro, profileImage: $profileImage, sex: $sex,  systemMessage: $systemMessage, welcomeMessage: $welcomeMessage, questions: $questions,  followers: $followers, following: $following, createTime: $createTime, modifiedTime: $modifiedTime)';
  }
}
