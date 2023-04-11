enum ChatRoomType { personal, conversation, unknown }

String getChatRoomType(ChatRoomType type) {
  switch (type) {
    case ChatRoomType.personal:
      return 'personal';
    case ChatRoomType.conversation:
      return 'conversation';
    default:
      return 'unknown';
  }
}

ChatRoomType getChatRoomTypeByString(String chatRoomType) {
  switch (chatRoomType) {
    case 'personal':
      return ChatRoomType.personal;
    case 'conversation':
      return ChatRoomType.conversation;
    default:
      return ChatRoomType.unknown;
  }
}
