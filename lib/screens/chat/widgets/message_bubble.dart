import 'package:flutter/material.dart';
import 'package:uni_talk/config/chat/message_sender.dart';
import 'package:uni_talk/models/chat_message.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage chatMessage;

  const MessageBubble({super.key, required this.chatMessage});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  late ChatMessage chatMessage;

  @override
  void initState() {
    super.initState();
    chatMessage = widget.chatMessage;
  }

  @override
  Widget build(BuildContext context) {
    bool isUser = chatMessage.sentBy == MessageSender.user;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              '',
              style: TextStyle(
                  fontSize: 13, fontFamily: 'Poppins', color: Colors.black87),
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(50),
              topLeft:
                  isUser ? const Radius.circular(50) : const Radius.circular(0),
              bottomRight: const Radius.circular(50),
              topRight:
                  isUser ? const Radius.circular(0) : const Radius.circular(50),
            ),
            color: isUser ? Colors.blue : Colors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                chatMessage.message,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.blue,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
