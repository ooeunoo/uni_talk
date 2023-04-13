import 'package:flutter/material.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/providers/chat_provider.dart';
import 'package:uni_talk/screens/chat/widgets/message_bubble.dart';

class ChatStream extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatStream({super.key, required this.chatRoom});

  @override
  State<ChatStream> createState() => _ChatStreamState();
}

class _ChatStreamState extends State<ChatStream> {
  late ChatRoom chatRoom;

  ChatProvider chatProvider = ChatProvider();

  @override
  void initState() {
    super.initState();
    chatRoom = widget.chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatProvider.streamChatMessages(chatRoom.id),
      //  _firestore
      //     .collection('chat_messages')
      //     .where('chatRoomId', isEqualTo: chatRoom.id)
      //     .orderBy('createTime')
      //     .snapshots(),
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.hasData) {
          final messages = snapshot.data!.docs.reversed;
          List<MessageBubble> messageWidgets = [];
          for (var message in messages) {
            final chatMessage = ChatMessage.fromDocumentSnapshot(message);
            final msgBubble = MessageBubble(
              key: ValueKey(chatMessage.id),
              chatMessage: chatMessage,
            );

            messageWidgets.add(msgBubble);
          }
          return Expanded(
            child: ListView(
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
