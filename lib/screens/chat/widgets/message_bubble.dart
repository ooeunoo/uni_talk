import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uni_talk/config/chat.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/models/storage_box.dart';
import 'package:uni_talk/providers/chat_provider.dart';
import 'package:uni_talk/providers/storage_box_provider.dart';
import 'package:uni_talk/screens/chat/widgets/storage_box_drawer.dart';
import 'package:uni_talk/widgets/snackbar.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage chatMessage;
  final bool isWriting;

  const MessageBubble({
    super.key,
    required this.chatMessage,
    required this.isWriting,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  final ChatProvider _chatProvider = ChatProvider();
  final StorageBoxProvider _storageBoxProvider = StorageBoxProvider();

  late ChatMessage chatMessage;
  late bool isWriting;

  bool showStorage = false;

  @override
  void initState() {
    super.initState();
    chatMessage = widget.chatMessage;
    isWriting = widget.isWriting;
  }

  @override
  void didUpdateWidget(MessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      setState(() {
        chatMessage = widget.chatMessage;
      });
    }
  }

  // 클립보드 복사하기
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: chatMessage.message));
    showTopSnackBar(
      context,
      const Text("Copied to clipboard!", style: TextStyle(color: Colors.white)),
    );
  }

  // 좋아요 토글
  void _toogleLike() {
    bool newState = !chatMessage.like;
    final updatedChatMessage = chatMessage.copyWith(like: newState);
    _chatProvider.updateMessage(chatMessage.id!, updatedChatMessage);

    if (newState) {
      setState(() {
        showStorage = true;
      });
    } else {
      setState(() {
        showStorage = false;
      });
    }
    _showBottomSheet();
  }

  void _handleSaveStorage(StorageBox storageBox) {
    StorageItem newItem =
        StorageItem(storageBoxId: storageBox.id!, data: chatMessage.message);
    _storageBoxProvider.saveStorageItem(storageBox.id!, newItem);
    setState(() {
      showStorage = false;
    });
    Navigator.pop(context); // Add this line to close the bottom sheet
  }

  void _showBottomSheet() {
    if (showStorage) {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        builder: (BuildContext context) {
          return StorageBoxDrawer(
              handleSaveStorage: (storageBoxId) =>
                  _handleSaveStorage(storageBoxId));
        },
      );
    }
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
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: isWriting
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: SizedBox(
                    width: isWriting ? 50 : 0,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: SpinKitThreeBounce(
                          size: 15, color: isUser ? Colors.white : Colors.blue),
                    ),
                  ),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Text(
                              chatMessage.message,
                              style: TextStyle(
                                color: isUser ? Colors.white : Colors.blue,
                                fontFamily: 'Poppins',
                                fontSize: 18,
                              ),
                            ),
                          )),
                    ],
                  )),
            ),
          ),
          if (!isUser && !isWriting)
            Row(
              children: [
                IconButton(
                  icon: chatMessage.like
                      ? const Icon(Icons.favorite, color: Colors.red)
                      : const Icon(Icons.favorite_border),
                  onPressed: () {
                    _toogleLike();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.content_copy),
                  onPressed: () {
                    _copyToClipboard();
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
