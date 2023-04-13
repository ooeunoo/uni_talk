import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/providers/user_provider.dart';
import 'package:uni_talk/services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  final StreamController<void> _chatRoomRefreshController =
      StreamController<void>.broadcast();

  // 채팅룸 목록을 새로 고침하기 위한 Stream을 추가합니다.
  Stream<void> get refreshStream => _chatRoomRefreshController.stream;

  // 채팅룸 새로고침하기
  Future<void> refreshChatRooms() async {
    _chatRoomRefreshController.add(null);
  }

  // 채팅룸 생성하기
  Future<void> createChatRoom(ChatRoom chatRoom) async {
    await _chatService.createChatRoom(chatRoom);
    notifyListeners();
  }

  // 채팅룸 목록 가져오기
  Stream<List<ChatRoomWithLastMessage>> getChatRoomsByUserId(
      {String? title, String? type, String? category, bool ascending = true}) {
    final currentUser = UserProvider().currentUser;

    if (currentUser == null) {
      return const Stream.empty();
    }
    return _chatService.getChatRoomsByUserId(
        userId: currentUser.uid,
        title: title,
        type: type,
        category: category,
        ascending: ascending);
  }

  // 메시지 스트림하기
  Stream<QuerySnapshot> streamChatMessages(String chatRoomId) {
    return _chatService.streamChatMessages(chatRoomId);
  }

  // 메시지 전송하기
  Future<void> sendMessage(ChatMessage chatMessage) async {
    await _chatService.sendMessage(chatMessage);
    notifyListeners();
  }
}
