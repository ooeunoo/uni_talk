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

  factory VirtualUser.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return VirtualUser(
      id: doc.id,
      name: data['name'],
      job: data['job'],
      profileId: data['profileId'],
      profileImage: data['profileImage'],
      profileIntro: data['profileIntro'],
      sex: data['sex'],
      systemMessage: data['systemMessage'],
      welcomeMessage: data['welcomeMessage'],
      questions: List<String>.from(data['questions']),
      followers: data['followers'],
      following: data['following'],
      createTime: data['createTime'] as Timestamp,
      modifiedTime: data['modifiedTime'] as Timestamp,
    );
  }

  factory VirtualUser.fromJson(Map<String, dynamic> json) {
    return VirtualUser(
      id: json['id'],
      name: json['name'],
      job: json['job'],
      profileId: json['profileId'],
      profileImage: json['profileImage'],
      profileIntro: json['profileIntro'],
      sex: json['sex'],
      systemMessage: json['systemMessage'],
      welcomeMessage: json['welcomeMessage'],
      questions: List<String>.from(json['questions']),
      followers: json['followers'],
      following: json['following'],
      createTime: Timestamp.fromMillisecondsSinceEpoch(json['createTime']),
      modifiedTime: Timestamp.fromMillisecondsSinceEpoch(json['modifiedTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'job': job,
      'profileId': profileId,
      'profileImage': profileImage,
      'profileIntro': profileIntro,
      'sex': sex,
      'systemMessage': systemMessage,
      'welcomeMessage': welcomeMessage,
      'questions': questions,
      'followers': followers,
      'following': following,
      'createTime': createTime,
      'modifiedTime': modifiedTime,
    };
  }

  @override
  String toString() {
    return 'VirtualUser(id: $id, name: $name, job: $job, profileId: $profileId, profileIntro: $profileIntro, profileImage: $profileImage, sex: $sex,  systemMessage: $systemMessage, welcomeMessage: $welcomeMessage, questions: $questions,  followers: $followers, following: $following, createTime: $createTime, modifiedTime: $modifiedTime)';
  }
}
