import 'package:flutter/material.dart';
import 'package:uni_talk/config/chat/message_sender.dart';
import 'package:uni_talk/config/theme.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/models/custom_theme.dart';
import 'package:uni_talk/providers/chat_provider.dart';
import 'package:uni_talk/screens/chat/widgets/chat_stream.dart';

String? messageText;

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatScreen({super.key, required this.chatRoom});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatRoom chatRoom;
  late ChatProvider chatProvider;

  final chatMsgTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    chatRoom = widget.chatRoom;
    chatProvider = ChatProvider();
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
      // drawer: Drawer(
      //   child: ListView(
      //     children: <Widget>[
      //       UserAccountsDrawerHeader(
      //         decoration: BoxDecoration(
      //           color: Colors.deepPurple[900],
      //         ),
      //         accountName: Text(username ?? ""),
      //         accountEmail: Text(email ?? ""),
      //         currentAccountPicture: const CircleAvatar(
      //           backgroundImage: NetworkImage(
      //               "https://cdn.clipart.email/93ce84c4f719bd9a234fb92ab331bec4_frisco-specialty-clinic-vail-health_480-480.png"),
      //         ),
      //         onDetailsPressed: () {},
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.exit_to_app),
      //         title: const Text("Logout"),
      //         subtitle: const Text("Sign out of this account"),
      //         onTap: () async {
      //           await _auth.signOut();
      //           Navigator.pushReplacementNamed(context, '/');
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ChatStream(),
          Container(
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
                        onChanged: (value) {
                          messageText = value;
                        },
                        controller: chatMsgTextController,
                        decoration: theme.chatRoomMessageTextField,
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                    shape: const CircleBorder(),
                    color: Colors.blue,
                    onPressed: () {
                      ChatMessage message = ChatMessage(
                          chatRoomId: chatRoom.id,
                          sentBy: MessageSender.user,
                          message: chatMsgTextController.text);
                      chatMsgTextController.clear();

                      chatProvider.sendMessage(message);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
