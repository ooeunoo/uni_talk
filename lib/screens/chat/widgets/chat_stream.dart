import 'package:flutter/material.dart';
import 'package:uni_talk/config/chat/message_sender.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/providers/chat_provider.dart';
import 'package:uni_talk/screens/chat/widgets/message_bubble.dart';
import 'package:uni_talk/utils/string.dart';

class ChatStream extends StatefulWidget {
  final ChatRoom chatRoom;
  final bool writingChatGPT;
  final ScrollController chatStreamScrollController;

  const ChatStream({
    super.key,
    required this.chatRoom,
    required this.chatStreamScrollController,
    required this.writingChatGPT,
  });

  @override
  State<ChatStream> createState() => _ChatStreamState();
}

class _ChatStreamState extends State<ChatStream> {
  late ChatRoom chatRoom;
  late ScrollController chatStreamScrollController;

  ChatProvider chatProvider = ChatProvider();

  @override
  void initState() {
    super.initState();
    chatRoom = widget.chatRoom;
    chatStreamScrollController = widget.chatStreamScrollController;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatProvider.streamChatMessages(chatRoom.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
            final chatMessage = ChatMessage(
                chatRoomId: chatRoom.id,
                sentBy: MessageSender.chatgpt,
                message: '');

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
          // 메시지를 불러오지 못했을때, <로딩>
          return const Center(
            child:
                CircularProgressIndicator(backgroundColor: Colors.deepPurple),
          );
        }
      },
    );
  }
}
