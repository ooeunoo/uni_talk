import 'package:flutter/material.dart';
import 'package:uni_talk/config/chat/message_sender.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/models/role_chat.dart';
import 'package:uni_talk/providers/chat_provider.dart';
import 'package:uni_talk/screens/chat/widgets/message_bubble.dart';
import 'package:uni_talk/utils/string.dart';

class RoleChatStream extends StatefulWidget {
  final ChatRoom chatRoom;
  final RoleChat roleChat;
  final bool writingChatGPT;
  final ScrollController chatStreamScrollController;

  const RoleChatStream({
    super.key,
    required this.chatRoom,
    required this.roleChat,
    required this.chatStreamScrollController,
    required this.writingChatGPT,
  });

  @override
  State<RoleChatStream> createState() => _RoleChatStreamState();
}

class _RoleChatStreamState extends State<RoleChatStream> {
  late ChatRoom chatRoom;
  late RoleChat roleChat;
  late ScrollController chatStreamScrollController;

  ChatProvider chatProvider = ChatProvider();

  @override
  void initState() {
    super.initState();
    chatRoom = widget.chatRoom;
    roleChat = widget.roleChat;

    chatStreamScrollController = widget.chatStreamScrollController;
  }

  ChatMessage initMessage() {
    return ChatMessage(
        chatRoomId: chatRoom.id!,
        sentBy: MessageSender.chatgpt,
        message: roleChat.systemMessage,
        like: false);
  }

  @override
  Widget build(BuildContext context) {
    return 
    StreamBuilder(
      stream: chatProvider.streamChatMessages(chatRoom.id!),
      builder: (context, snapshot) {
        // 여기에서 메시지를 가져옵니다.
        List<ChatMessage> getChatMessages() {
          List<ChatMessage> chatMessages = [];

          if (snapshot.hasData) {
            final messages = snapshot.data!.docs.reversed;

            for (var message in messages) {
              final chatMessage = ChatMessage.fromDocumentSnapshot(message);
              chatMessages.add(chatMessage);
            }
          }

          return chatMessages;
        }

        if (snapshot.hasData) {
          // Existing chat messages
          final messages = snapshot.data!.docs.reversed;
          List<MessageBubble> messageWidgets = [];
          for (var message in messages) {
            final chatMessage = ChatMessage.fromDocumentSnapshot(message);
            final msgBubble = MessageBubble(
              key: ValueKey(chatMessage.id),
              chatMessage: chatMessage,
              isWriting: false,
            );

            messageWidgets.add(msgBubble);
          }

          if (widget.writingChatGPT) {
            // User is typing a message to ChatGPT
            final chatMessage = ChatMessage(
                chatRoomId: chatRoom.id!,
                sentBy: MessageSender.chatgpt,
                message: '',
                like: false);

            messageWidgets.insert(
                0,
                MessageBubble(
                    key: getValueKey(),
                    chatMessage: chatMessage,
                    isWriting: true));
          }

          return Expanded(
            child: ListView(
              controller: chatStreamScrollController,
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              children: messageWidgets,
            ),
          );
        } else {
          // Loading indicator
          return const Center(
            child:
                CircularProgressIndicator(backgroundColor: Colors.deepPurple),
          );
        }
      },
    );
  }
}
