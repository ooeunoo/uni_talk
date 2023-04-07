import 'package:flutter/material.dart';

class ChatItem extends StatefulWidget {
  const ChatItem({super.key});

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (details) {
        setState(() {
          backgroundColor = Colors.grey[100]!;
        });
      },
      onTapUp: (details) {
        setState(() {
          backgroundColor = Colors.white;
        });
      },
      onTapCancel: () {
        setState(() {
          backgroundColor = Colors.white;
        });
      },
      child: Container(
        height: 100,
        color: backgroundColor,
        child: const Center(
          child: Text('Chat item '),
        ),
      ),
    );
  }
}
