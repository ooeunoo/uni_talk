import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uni_talk/config/chat.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/providers/chat_provider.dart';
import 'package:uni_talk/providers/user_provider.dart';

class CreateChatScreen extends StatefulWidget {
  const CreateChatScreen({super.key});

  @override
  State<CreateChatScreen> createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen> {
  UserProvider userProvider = UserProvider();
  ChatProvider chatProvider = ChatProvider();

  final titleTextController = TextEditingController();

  bool validateTitle = false;

  @override
  void dispose() {
    titleTextController.dispose();
    super.dispose();
  }

  void checkValidateTitle() {
    if (titleTextController.text.isNotEmpty &&
        titleTextController.text.length < 10) {
      setState(() {
        validateTitle = true;
      });
    } else {
      setState(() {
        validateTitle = false;
      });
    }
  }

  Future<ChatRoom?> createChatRoom() async {
    User? user = userProvider.currentUser;
    if (user == null) {
      return null;
    }

    ChatRoom chatRoom = ChatRoom(
      userId: user.uid,
      title: titleTextController.text,
      type: ChatRoomType.personal,
      image: 'https://source.unsplash.com/random/640x480', // 랜덤 이미지 URL 생성
    );

    ChatRoom newChatRoom = await chatProvider.createChatRoom(chatRoom);
    return newChatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: Material(
                child: Container(
                  padding: const EdgeInsets.all(30.0),
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 30.0)),
                        const Text(
                          '채팅방 제목을 입력해주세요.',
                          style: TextStyle(color: Colors.black, fontSize: 25.0),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 50.0)),
                        TextFormField(
                          controller: titleTextController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(),
                            ),
                          ),
                          onChanged: (String? val) {
                            checkValidateTitle();
                          },
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
              child: SizedBox(
                height: 50.0,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: validateTitle
                      ? () async {
                          ChatRoom? chatRoom = await createChatRoom();
                          if (chatRoom != null) {
                            Navigator.of(context).pop();
                          }
                        }
                      : null,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  child: const Text('생성'),
                ),
              ),
            ),
          ],
        ));
  }
}
