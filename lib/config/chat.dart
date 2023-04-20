enum ChatRoomType { personal, virtualUser, unknown }

enum MessageSender { user, chatgpt, unknown }

String getChatRoomType(ChatRoomType type) {
  switch (type) {
    case ChatRoomType.personal:
      return 'personal';
    case ChatRoomType.virtualUser:
      return 'virtualUser';
    default:
      return 'unknown';
  }
}

ChatRoomType getChatRoomTypeByString(String chatRoomType) {
  switch (chatRoomType) {
    case 'personal':
      return ChatRoomType.personal;
    case 'virtualUser':
      return ChatRoomType.virtualUser;
    default:
      return ChatRoomType.unknown;
  }
}

String getMessageSender(MessageSender sender) {
  switch (sender) {
    case MessageSender.user:
      return 'user';
    case MessageSender.chatgpt:
      return 'chatgpt';
    default:
      return 'unknown';
  }
}

MessageSender getMessageSenderByString(String sender) {
  switch (sender) {
    case 'user':
      return MessageSender.user;
    case 'chatgpt':
      return MessageSender.chatgpt;
    default:
      return MessageSender.unknown;
  }
}
