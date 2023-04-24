import 'package:cloud_firestore/cloud_firestore.dart';

class StorageItem {
  final String? id;
  final String storageBoxId;
  final String data;
  final Timestamp? createTime;
  final Timestamp? modifiedTime;

  StorageItem(
      {this.id,
      required this.storageBoxId,
      required this.data,
      this.createTime,
      this.modifiedTime});

  factory StorageItem.fromJson(Map<String, dynamic> json) {
    return StorageItem(
      id: json['id'],
      storageBoxId: json['storageBoxId'],
      data: json['data'],
      createTime: json['createTime'],
      modifiedTime: json['modifiedTime'],
    );
  }
}

class StorageBox {
  final String? id;
  final String userId;
  final String icon;
  final String title;
  final int totalItems;
  final Timestamp? createTime;
  final Timestamp? modifiedTime;

  StorageBox(
      {this.id,
      required this.icon,
      required this.userId,
      required this.title,
      required this.totalItems,
      this.createTime,
      this.modifiedTime});

  factory StorageBox.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return StorageBox(
      id: doc.id,
      userId: data['userId'],
      icon: data['icon'],
      title: data['title'],
      totalItems: data['totalItems'],
      createTime: data['createTime'],
      modifiedTime: data['modifiedTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'icon': icon,
      'title': title,
      'totalItems': totalItems,
      'createTime': createTime,
      'modifiedTime': modifiedTime,
    };
  }
}
