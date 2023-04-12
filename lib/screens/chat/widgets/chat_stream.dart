import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/screens/chat/widgets/message_bubble.dart';

class ChatStream extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;

  ChatStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore
          .collection('chat_messages')
          .orderBy('createTime')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data!.docs.reversed;
          List<MessageBubble> messageWidgets = [];
          for (var message in messages) {
            final chatMessage = ChatMessage.fromDocumentSnapshot(message);
            final msgBubble = MessageBubble(
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
          return const Center(
            child:
                CircularProgressIndicator(backgroundColor: Colors.deepPurple),
          );
        }
      },
    );
  }
}
