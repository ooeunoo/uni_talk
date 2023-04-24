import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uni_talk/models/storage_box.dart';
import 'package:uni_talk/services/storage_box_service.dart';

class StorageBoxProvider with ChangeNotifier {
  final StorageBoxService _storageBoxService = StorageBoxService();

  // Get Users query
  Query<StorageBox> getStorageBoxReferences(String userId) {
    return _storageBoxService.getStorageBoxReferences(userId);
  }

  // 스토리지 박스 생성하기
  Future<StorageBox> createStorageBox(StorageBox storageBox) async {
    final newStorageBox = await _storageBoxService.createStorageBox(storageBox);
    notifyListeners();
    return newStorageBox;
  }

  Future<void> saveStorageItem(
      String storageBoxId, StorageItem storageItem) async {
    await _storageBoxService.saveStorageItem(storageBoxId, storageItem);
    notifyListeners();
  }
}
