import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uni_talk/config/chat.dart';
import 'package:uni_talk/config/theme.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/models/custom_theme.dart';
import 'package:uni_talk/models/virtual_user.dart';
import 'package:uni_talk/providers/chat_provider.dart';
import 'package:uni_talk/providers/openai_provider.dart';
import 'package:uni_talk/providers/virtual_user_provider.dart';
import 'package:uni_talk/screens/chat/widgets/message_bubble.dart';
import 'package:uni_talk/utils/string.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';

class VirtualUserChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  const VirtualUserChatScreen({super.key, required this.chatRoom});

  @override
  State<VirtualUserChatScreen> createState() => _VirtualUserChatScreenState();
}

class _VirtualUserChatScreenState extends State<VirtualUserChatScreen>
    with SingleTickerProviderStateMixin {
  late ChatRoom chatRoom;

  final ChatProvider chatProvider = ChatProvider();
  final VirtualUserProvider virtualUserProvider = VirtualUserProvider();
  final OpenAIProvider openAIProvider = OpenAIProvider();

  final chatMsgTextController = TextEditingController();
  final ScrollController chatStreamScrollController = ScrollController();

  List<ChatMessage> prevMessages = [];

  bool errorOfChatGPT = false; // error: true,
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
  String? sendMessageByUser() {
    if (chatMsgTextController.text.isEmpty) return null;

    ChatMessage userMessage = ChatMessage(
        chatRoomId: chatRoom.id!,
        sentBy: MessageSender.user,
        message: chatMsgTextController.text,
        like: false);
    chatMsgTextController.clear();

    chatProvider.sendMessage(userMessage);

    scrollToBottom();

    return userMessage.message;
  }

  // ChatGPT 메시지 수신
  Future<void> receiveMessageByChatGPT(
      VirtualUser virtualUser, String message) async {
    toogleWritingChatGPT();

    String? answer = await openAIProvider.askToChatGPTForRole(
        virtualUser.systemMessage, prevMessages, message);

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

  // 최초 메시지인지
  bool isFirstMessage(List<ChatMessage> prevMessages) {
    return prevMessages.length == 1 &&
        prevMessages[0].sentBy == MessageSender.chatgpt;
  }

  // 랜덤으로 추천 질문 가져오기
  List<String> getRandomQuestions(VirtualUser virtualUser, int numOfQuestions) {
    if (virtualUser.questions.length <= numOfQuestions) {
      return virtualUser.questions;
    }

    List<String> randomQuestions = [];
    Set<int> selectedIndices = {};

    while (selectedIndices.length < numOfQuestions) {
      int randomIndex = Random().nextInt(virtualUser.questions.length);
      if (!selectedIndices.contains(randomIndex)) {
        selectedIndices.add(randomIndex);
        randomQuestions.add(virtualUser.questions[randomIndex]);
      }
    }

    return randomQuestions;
  }

  @override
  Widget build(BuildContext context) {
    CustomTheme theme = getThemeData(Theme.of(context).brightness);

    return FutureBuilder(
        future: virtualUserProvider.getVirtualUser(chatRoom.virtualUserId!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          VirtualUser? virtualUser = snapshot.data;

          if (virtualUser == null) {
            return Container();
          }

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
                  //       valueColor:
                  //           const AlwaysStoppedAnimation<Color>(Colors.white),
                  //       backgroundColor: Colors.blue[100],
                  //     ),
                  //   ),
                  // ),
                  backgroundColor: Colors.white10,
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                              child: CachedNetworkImage(
                            imageUrl: virtualUser.profileImage,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )),
                        ),
                      ),
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
                          Text(
                            virtualUser.profileIntro,
                            style: theme.chatRoomAppBarSubTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
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
                          // Existing chat messages
                          final messages = snapshot.data!.docs.reversed;
                          List<Widget> messageWidgets = [];
                          prevMessages = [];

                          for (var message in messages) {
                            final chatMessage =
                                ChatMessage.fromDocumentSnapshot(message);
                            final msgBubble = MessageBubble(
                              key: ValueKey(chatMessage.id),
                              chatMessage: chatMessage,
                              isWriting: false,
                            );

                            messageWidgets.add(msgBubble);
                            prevMessages.add(chatMessage);
                          }

                          if (writingChatGPT) {
                            // User is typing a message to ChatGPT
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

                          if (isFirstMessage(prevMessages)) {
                            Widget recommend = Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: const Text(
                                          '추천 질문 ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Column(
                                        children: <Widget>[
                                          ...getRandomQuestions(virtualUser, 3)
                                              .map(
                                            (question) => Card(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              elevation: 5.0,
                                              child: InkWell(
                                                onTap: () {
                                                  // 추천 질문 클릭 시 동작하는 로직 구현
                                                  chatMsgTextController.text =
                                                      question;
                                                  String? message =
                                                      sendMessageByUser();
                                                  if (message != null) {
                                                    receiveMessageByChatGPT(
                                                        virtualUser, message);
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 10,
                                                    horizontal: 20,
                                                  ),
                                                  child: Text(
                                                    question,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ));
                            messageWidgets.insert(0, recommend);
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
                          // Loading indicator
                          return const Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.deepPurple),
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
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
                                    decoration: theme
                                        .chatRoomMessageHintTextField
                                        .copyWith(
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
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
                                String? message = sendMessageByUser();
                                if (message != null) {
                                  receiveMessageByChatGPT(virtualUser, message);
                                }
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
        });
  }
}
