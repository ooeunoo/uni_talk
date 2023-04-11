enum MessageSender { user, chatgpt, unknown }

// Converting MessageSender to String for storage or display purposes
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
