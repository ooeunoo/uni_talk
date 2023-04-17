import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/providers/user_provider.dart';
import 'package:uni_talk/services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  final UserProvider _userProvider = UserProvider();

  // 채팅룸 생성하기
  Future<ChatRoom> createChatRoom(ChatRoom chatRoom) async {
    final createdChatRoom = await _chatService.createChatRoom(chatRoom);
    notifyListeners();
    return createdChatRoom;
  }

  // 채팅룸 스트림하기
  Stream<QuerySnapshot> streamChatRooms(
      {String? title, String? type, String? category, bool ascending = true}) {
    final currentUser = _userProvider.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }

    return _chatService.streamChatRooms(userId: currentUser.uid);
  }

  // 롤챗이 존재하는지
  Future<ChatRoom?> getExistingChatRoom(
      String userId, String roleChatId) async {
    final existingChatRoom =
        await _chatService.getExistingChatRoom(userId, roleChatId);
    notifyListeners();
    return existingChatRoom;
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

  // 메시지 업데이트하기
  Future<void> updateMessage(
      String messageId, ChatMessage updatedChatMessage) async {
    await _chatService.updateMessage(messageId, updatedChatMessage);
    notifyListeners();
  }
}
