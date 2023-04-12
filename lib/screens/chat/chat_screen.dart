import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_talk/models/chat_room.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatScreen({super.key, required this.chatRoom});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _showEmojiPicker = false;
  bool _showSendButton = false;
  final FocusNode _messageFocusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messageFocusNode.addListener(_onMessageFocusChanged);
  }

  @override
  void dispose() {
    _messageFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onMessageFocusChanged() {
    setState(() {
      // Update the UI when the input field gains or loses focus
    });
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
    });
  }

  void _toggleSendButton(bool show) {
    setState(() {
      _showSendButton = show;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      CupertinoIcons.back,
                      color: theme.appBarTheme.iconTheme?.color!,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                const SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.chatRoom.image!),
                  maxRadius: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          widget.chatRoom.title.length > 10
                              ? '${widget.chatRoom.title.substring(0, 10)}∙∙∙'
                              : widget.chatRoom.title,
                          overflow: TextOverflow.clip,
                          style: theme.textTheme.titleSmall),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                CupertinoButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  child: Icon(
                    CupertinoIcons.ellipsis,
                    color: theme.appBarTheme.iconTheme?.color!,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
