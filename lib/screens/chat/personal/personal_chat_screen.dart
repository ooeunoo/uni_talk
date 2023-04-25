import 'package:flutter/material.dart';
import 'package:uni_talk/config/chat.dart';
import 'package:uni_talk/config/theme.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/models/custom_theme.dart';
import 'package:uni_talk/providers/chat_provider.dart';
import 'package:uni_talk/providers/openai_provider.dart';
import 'package:uni_talk/screens/chat/widgets/message_bubble.dart';
import 'package:uni_talk/screens/chat/personal/personal_message_input_box.dart';
import 'package:uni_talk/utils/string.dart';
import 'package:bottom_drawer/bottom_drawer.dart';

class PersonalChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  const PersonalChatScreen({super.key, required this.chatRoom});

  @override
  State<PersonalChatScreen> createState() => _PersonalChatScreenState();
}

class _PersonalChatScreenState extends State<PersonalChatScreen>
    with SingleTickerProviderStateMixin {
  late ChatRoom chatRoom;

  final ChatProvider chatProvider = ChatProvider();
  final OpenAIProvider openAIProvider = OpenAIProvider();

  final chatMsgTextController = TextEditingController();
  final ScrollController chatStreamScrollController = ScrollController();
  BottomDrawerController storageDrawerController = BottomDrawerController();

  List<ChatMessage> prevMessages = [];

  bool errorOfChatGPT = false;
  bool writingChatGPT = false;

  @override
  void initState() {
    super.initState();

    chatRoom = widget.chatRoom;
  }

  @override
  void dispose() {
    chatStreamScrollController.dispose();
    chatMsgTextController.dispose();
    super.dispose();
  }

  // chatgpt 글 작성중 상태 토글링
  void _toggleWritingChatGPT() {
    setState(() {
      writingChatGPT = !writingChatGPT;
    });
  }

  // chatGPT 상태 변화
  void _changeStateChatGPT(bool state) {
    setState(() {
      errorOfChatGPT = state;
    });
  }

  // 최하단으로 스크롤
  void _scrollToBottom() {
    chatStreamScrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // 사용자 메시지 송신 -> ChatGPT 메시지 수신
  Future<void> _startConversation(String message) async {
    if (message.isEmpty) return;

    List<ChatMessage> injectedMessages = prevMessages;

    await _sendMessageByUser(message);
    await _receiveMessageByChatGPT(injectedMessages, message);
  }

  // 사용자 메시지 송신
  Future<void> _sendMessageByUser(String message) async {
    ChatMessage userMessage = ChatMessage(
        chatRoomId: chatRoom.id!,
        sentBy: MessageSender.user,
        message: message,
        like: false);
    chatMsgTextController.clear();

    chatProvider.sendMessage(userMessage);

    _scrollToBottom();
  }

  // ChatGPT 메시지 수신
  Future<void> _receiveMessageByChatGPT(
      List<ChatMessage> injectedMessages, String message) async {
    _toggleWritingChatGPT();

    String? answer =
        await openAIProvider.askToChatGPTForPersonal(injectedMessages, message);

    if (answer == null) {
      _changeStateChatGPT(true);
    } else {
      _changeStateChatGPT(false);
      ChatMessage chatgptMessage = ChatMessage(
          chatRoomId: chatRoom.id!,
          sentBy: MessageSender.chatgpt,
          message: answer,
          like: false);

      chatProvider.sendMessage(chatgptMessage);
    }

    _toggleWritingChatGPT();
  }

  @override
  Widget build(BuildContext context) {
    CustomTheme theme = getThemeData(Theme.of(context).brightness);

    return GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 50) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 80,
              iconTheme: theme.chatRoomAppBarIcon,
              elevation: 0,
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
                    ],
                  ),
                ],
              ),
              // actions: <Widget>[
              //   Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 10),
              //     child: GestureDetector(
              //       child: const Icon(Icons.more_vert),
              //     ),
              //   )
              // ],
            ),
            body: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    StreamBuilder(
                      stream: chatProvider.streamChatMessages(chatRoom.id!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final messages = snapshot.data!.docs.reversed;
                          List<MessageBubble> messageWidgets = [];
                          prevMessages = [];

                          for (var message in messages) {
                            final chatMessage =
                                ChatMessage.fromDocumentSnapshot(message);
                            final msgBubble = MessageBubble(
                              key: ValueKey(chatMessage.id),
                              chatMessage: chatMessage,
                            );

                            messageWidgets.add(msgBubble);
                            prevMessages.add(chatMessage);
                          }

                          return Expanded(
                            child: ListView(
                              controller: chatStreamScrollController,
                              reverse: true,
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              children: messageWidgets,
                            ),
                          );
                        } else {
                          // 메시지를 불러오지 못했을때, <로딩>
                          return const Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.deepPurple),
                          );
                        }
                      },
                    ),
                    PersonalMessageInputBox(
                        msgController: chatMsgTextController,
                        startConversation: (msg) => _startConversation(msg),
                        enable: !writingChatGPT)
                  ],
                ),
              ],
            )));
  }
}
