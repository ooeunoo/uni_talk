import 'package:flutter/material.dart';
import 'package:uni_talk/config/chat/message_sender.dart';
import 'package:uni_talk/config/theme.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/models/custom_theme.dart';
import 'package:uni_talk/providers/chat_provider.dart';
import 'package:uni_talk/providers/openai_provider.dart';
import 'package:uni_talk/screens/chat/widgets/chat_stream.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatScreen({super.key, required this.chatRoom});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late ChatRoom chatRoom;
  late AnimationController _animationController;

  final ChatProvider chatProvider = ChatProvider();
  final OpenAIProvider openAIProvider = OpenAIProvider();

  final chatMsgTextController = TextEditingController();
  final ScrollController chatStreamScrollController = ScrollController();

  bool writingChatGPT = false;

  @override
  void initState() {
    super.initState();

    chatRoom = widget.chatRoom;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // chatgpt 글 작성중 상태 토글링
  void toogleWritingChatGPT() {
    setState(() {
      writingChatGPT = !writingChatGPT;
    });
  }

  // 최하단으로 스크롤
  void scrollToBottom() {
    chatStreamScrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // 사용자 메시지 송신
  void sendMessageByUser() {
    if (chatMsgTextController.text.isEmpty) return;

    ChatMessage userMessage = ChatMessage(
        chatRoomId: chatRoom.id,
        sentBy: MessageSender.user,
        message: chatMsgTextController.text);
    chatMsgTextController.clear();

    chatProvider.sendMessage(userMessage);

    receiveMessageByChatGPT(userMessage.message);

    scrollToBottom();
  }

  // ChatGPT 메시지 수신
  Future<void> receiveMessageByChatGPT(String message) async {
    toogleWritingChatGPT();

    String answer = await openAIProvider.askToChatGPT([], message);

    ChatMessage chatgptMessage = ChatMessage(
        chatRoomId: chatRoom.id,
        sentBy: MessageSender.chatgpt,
        message: answer);

    chatProvider.sendMessage(chatgptMessage);

    toogleWritingChatGPT();
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
            chatStreamScrollController: chatStreamScrollController,
            writingChatGPT: writingChatGPT,
          ),
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
                          // enabled: !wrtingChatGPT,
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
