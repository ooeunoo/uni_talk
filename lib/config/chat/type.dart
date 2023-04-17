enum ChatRoomType { personal, role, unknown }

String getChatRoomType(ChatRoomType type) {
  switch (type) {
    case ChatRoomType.personal:
      return 'personal';
    case ChatRoomType.role:
      return 'role';
    default:
      return 'unknown';
  }
}

ChatRoomType getChatRoomTypeByString(String chatRoomType) {
  switch (chatRoomType) {
    case 'personal':
      return ChatRoomType.personal;
    case 'role':
      return ChatRoomType.role;
    default:
      return ChatRoomType.unknown;
  }
}
