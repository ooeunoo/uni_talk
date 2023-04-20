import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_talk/config/chat.dart';
import 'package:uni_talk/config/theme.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/models/custom_theme.dart';
import 'package:uni_talk/providers/chat_provider.dart';
import 'package:uni_talk/providers/openai_provider.dart';
import 'package:uni_talk/screens/chat/widgets/message_bubble.dart';
import 'package:uni_talk/utils/string.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatScreen({super.key, required this.chatRoom});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late ChatRoom chatRoom;

  final ChatProvider chatProvider = ChatProvider();
  final OpenAIProvider openAIProvider = OpenAIProvider();

  final chatMsgTextController = TextEditingController();
  final ScrollController chatStreamScrollController = ScrollController();

  bool errorOfChatGPT = false;
  bool writingChatGPT = false;

  @override
  void initState() {
    super.initState();

    chatRoom = widget.chatRoom;
  }

  // chatgpt 글 작성중 상태 토글링
  void toogleWritingChatGPT() {
    setState(() {
      writingChatGPT = !writingChatGPT;
    });
  }

  // chatGPT 상태 변화
  void changeStateChatGPT(bool state) {
    setState(() {
      errorOfChatGPT = state;
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
        chatRoomId: chatRoom.id!,
        sentBy: MessageSender.user,
        message: chatMsgTextController.text,
        like: false);
    chatMsgTextController.clear();

    chatProvider.sendMessage(userMessage);

    receiveMessageByChatGPT(userMessage.message);

    scrollToBottom();
  }

  // ChatGPT 메시지 수신
  Future<void> receiveMessageByChatGPT(String message) async {
    toogleWritingChatGPT();

    String? answer = await openAIProvider.askToChatGPTForPersonal([], message);

    if (answer == null) {
      changeStateChatGPT(true);
    } else {
      changeStateChatGPT(false);
      ChatMessage chatgptMessage = ChatMessage(
          chatRoomId: chatRoom.id!,
          sentBy: MessageSender.chatgpt,
          message: answer,
          like: false);

      chatProvider.sendMessage(chatgptMessage);
    }

    toogleWritingChatGPT();
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
            iconTheme: theme.chatRoomAppBarIcon,
            elevation: 0,
            // bottom: PreferredSize(
            //   preferredSize: const Size(25, 10),
            //   child: Container(
            //     decoration: BoxDecoration(
            //         color: Colors.blue,
            //         borderRadius: BorderRadius.circular(20)),
            //     constraints: const BoxConstraints.expand(height: 1),
            //     child: LinearProgressIndicator(
            //       valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            //       backgroundColor: Colors.blue[100],
            //     ),
            //   ),
            // ),
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
              StreamBuilder(
                stream: chatProvider.streamChatMessages(chatRoom.id!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final messages = snapshot.data!.docs.reversed;
                    List<MessageBubble> messageWidgets = [];
                    for (var message in messages) {
                      final chatMessage =
                          ChatMessage.fromDocumentSnapshot(message);
                      final msgBubble = MessageBubble(
                        key: ValueKey(chatMessage.id),
                        chatMessage: chatMessage,
                        isWriting: false,
                      );

                      messageWidgets.add(msgBubble);
                    }

                    if (writingChatGPT) {
                      final chatMessage = ChatMessage(
                          chatRoomId: chatRoom.id!,
                          sentBy: MessageSender.chatgpt,
                          message: '',
                          like: false);

                      messageWidgets.insert(
                          0,
                          MessageBubble(
                              key: getValueKey(),
                              chatMessage: chatMessage,
                              isWriting: true));
                    } else {
                      if (errorOfChatGPT) {
                        final chatMessage = ChatMessage(
                            chatRoomId: chatRoom.id!,
                            sentBy: MessageSender.chatgpt,
                            message: '죄송해요 잠시 오류가 발생했어요.',
                            like: false);

                        messageWidgets.insert(
                            0,
                            MessageBubble(
                                key: getValueKey(),
                                chatMessage: chatMessage,
                                isWriting: false));
                      }
                    }

                    return Expanded(
                      child: ListView(
                        controller: chatStreamScrollController,
                        reverse: true,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Material(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 2, bottom: 2),
                            child: TextField(
                              controller: chatMsgTextController,
                              style: theme.chatRoomMessageTextField,
                              decoration:
                                  theme.chatRoomMessageHintTextField.copyWith(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                enabled: !writingChatGPT,
                              ),
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
                          CupertinoIcons.paperplane,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
