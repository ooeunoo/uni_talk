import 'package:flutter/material.dart';
import 'package:uni_talk/config/chat/message_sender.dart';
import 'package:uni_talk/config/theme.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/models/custom_theme.dart';
import 'package:uni_talk/providers/chat_provider.dart';
import 'package:uni_talk/providers/openai_provider.dart';
import 'package:uni_talk/screens/chat/widgets/chat_stream.dart';
import 'package:uni_talk/screens/chat/widgets/writing_bubble.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatScreen({super.key, required this.chatRoom});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatRoom chatRoom;

  final ChatProvider chatProvider = ChatProvider();
  final OpenAIProvider openAIProvider = OpenAIProvider();

  final chatMsgTextController = TextEditingController();

  bool enableChat = true;

  @override
  void initState() {
    super.initState();

    chatRoom = widget.chatRoom;
  }

  // 채팅 활성화 토글링
  void toogleEnableChat() {
    setState(() {
      enableChat = !enableChat;
    });
  }

  void sendMessageByUser() {
    if (chatMsgTextController.text.isEmpty) return;

    ChatMessage userMessage = ChatMessage(
        chatRoomId: chatRoom.id,
        sentBy: MessageSender.user,
        message: chatMsgTextController.text);
    chatMsgTextController.clear();

    chatProvider.sendMessage(userMessage);

    receiveMessageByChatGPT(userMessage.message);
  }

  Future<void> receiveMessageByChatGPT(String message) async {
    toogleEnableChat();

    String answer = await openAIProvider.askToChatGPT([], message);

    ChatMessage chatgptMessage = ChatMessage(
        chatRoomId: chatRoom.id,
        sentBy: MessageSender.chatgpt,
        message: answer);

    toogleEnableChat();

    chatProvider.sendMessage(chatgptMessage);
  }

  @override
  Widget build(BuildContext context) {
    CustomTheme theme = getThemeData(Theme.of(context).brightness);

    return Scaffold(
      appBar: AppBar(
        iconTheme: theme.chatRoomAppBarIcon,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size(25, 10),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            constraints: const BoxConstraints.expand(height: 1),
            child: LinearProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: Colors.blue[100],
            ),
          ),
        ),
        backgroundColor: Colors.white10,
        title: Row(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(chatRoom.image!),
                )),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  chatRoom.title.length > 10
                      ? '${chatRoom.title.substring(0, 10)} ∙∙∙'
                      : chatRoom.title,
                  overflow: TextOverflow.clip,
                  style: theme.chatRoomAppBarTitle,
                ),
                // Text('by ishandeveloper', style: theme.chatRoomAppBarSubTitle)
              ],
            ),
          ],
        ),
        actions: <Widget>[
          GestureDetector(
            child: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ChatStream(
            key: ValueKey(chatRoom.id),
            chatRoom: chatRoom,
          ),
          if (!enableChat) const WrittingBubble(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Material(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      elevation: 5,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
                        child: TextField(
                          controller: chatMsgTextController,
                          decoration: theme.chatRoomMessageTextField,
                          enabled: enableChat,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  IconButton(
                    color: Colors.blue,
                    onPressed: () {
                      sendMessageByUser();
                    },
                    icon: const Icon(
                      Icons.send,
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
