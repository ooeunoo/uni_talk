import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:uni_talk/config/chat.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/models/storage_box.dart';
import 'package:uni_talk/providers/storage_box_provider.dart';
import 'package:uni_talk/screens/chat/widgets/storage_box_drawer.dart';
import 'package:uni_talk/widgets/snackbar.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage chatMessage;

  const MessageBubble({
    super.key,
    required this.chatMessage,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  final StorageBoxProvider _storageBoxProvider = StorageBoxProvider();

  late ChatMessage chatMessage;

  @override
  void initState() {
    super.initState();
    chatMessage = widget.chatMessage;
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
      const Text("복사 완료!", style: TextStyle(color: Colors.white)),
    );
  }

  void _handleSaveStorage(StorageBox storageBox) {
    StorageItem newItem =
        StorageItem(storageBoxId: storageBox.id!, data: chatMessage.message);
    _storageBoxProvider.saveStorageItem(storageBox.id!, newItem);
    showTopSnackBar(
      context,
      const Text("저장 완료!", style: TextStyle(color: Colors.white)),
    );
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void _showBottomSheet() {
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

  @override
  Widget build(BuildContext context) {
    bool isUser = chatMessage.sentBy == MessageSender.user;
    const double padding = 12;

    final styleSheet = MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      p: const TextStyle(
          fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
      h1: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
      h2: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      h3: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      h4: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      h5: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      h6: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      // emphasis
      em: const TextStyle(
        fontStyle: FontStyle.italic,
      ),
      strong: const TextStyle(fontWeight: FontWeight.bold),
      // links
      a: const TextStyle(
          color: Colors.blue, decoration: TextDecoration.underline),
      // code
      codeblockDecoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      codeblockPadding: const EdgeInsets.all(8),
      code: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        backgroundColor: Colors.transparent,
        fontFamily: 'monospace',
      ),
      // blockquotes
      blockquoteDecoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      blockquotePadding: const EdgeInsets.all(16),
      // horizontal rule
      horizontalRuleDecoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 2,
            color: Colors.grey,
          ),
        ),
      ),
    );
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(color: Colors.blue, width: 2.0),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    trailing: const Icon(CupertinoIcons.doc_on_clipboard_fill),
                    title: const Text('복사'),
                    onTap: () {
                      _copyToClipboard();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    trailing: const Icon(CupertinoIcons.folder_fill),
                    title: const Text('저장'),
                    onTap: () {
                      _showBottomSheet();
                    },
                  ),
                  ListTile(
                    trailing: const Icon(CupertinoIcons.share_solid),
                    title: const Text('공유'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Material(
              borderRadius: BorderRadius.only(
                bottomLeft: const Radius.circular(40),
                topLeft: isUser
                    ? const Radius.circular(40)
                    : const Radius.circular(0),
                bottomRight: const Radius.circular(40),
                topRight: isUser
                    ? const Radius.circular(0)
                    : const Radius.circular(40),
              ),
              color: isUser ? Colors.grey[700] : Colors.grey[300],
              elevation: 8,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: MarkdownBody(
                          data: chatMessage.message,
                          styleSheet: styleSheet,
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
