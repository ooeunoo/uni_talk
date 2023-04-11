// chat_screen.dart 파일

import 'package:flutter/material.dart';
import 'package:uni_talk/models/chat_room.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatScreen({super.key, required this.chatRoom});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FractionallySizedBox(
          widthFactor: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.chatRoom.image as String),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.chatRoom.title[0],
                  style: const TextStyle(color: Colors.black),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            const Expanded(
              child: Text(""),
              // 메시지 목록을 표시하는 위젯을 여기에 추가하세요.
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      // 메시지 전송 로직을 여기에 추가하세요.
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
