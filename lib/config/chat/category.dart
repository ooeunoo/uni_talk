enum ChatRoomCategory { sports, medical, unknown }

String? getChatRoomCategory(ChatRoomCategory category) {
  switch (category) {
    case ChatRoomCategory.sports:
      return 'sports';
    case ChatRoomCategory.medical:
      return 'medical';
    default:
      return null;
  }
}

ChatRoomCategory getChatRoomCategoryByString(String chatRoom) {
  switch (chatRoom) {
    case 'sports':
      return ChatRoomCategory.sports;
    case 'medical':
      return ChatRoomCategory.medical;
    default:
      return ChatRoomCategory.unknown;
  }
}
