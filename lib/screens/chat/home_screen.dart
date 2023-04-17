import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/providers/chat_provider.dart';
import 'package:uni_talk/providers/user_provider.dart';
import 'package:uni_talk/screens/chat/create_chat_screen.dart';
import 'package:uni_talk/screens/chat/search_screen.dart';
import 'package:uni_talk/screens/chat/widgets/chat_item.dart';
import 'package:uni_talk/utils/navigate.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  String selectedCategory = 'ALL';

  late UserProvider _userProvider;
  late ChatProvider _chatProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
  }

  Future<void> _refreshChatRooms() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    double screenHeight = MediaQuery.of(context).size.height;
    double categoryHeight = screenHeight * 0.05;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: const Icon(CupertinoIcons.search),
              onPressed: () {
                navigateTo(
                    context, const SearchScreen(), TransitionType.slideLeft);
              },
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Chat list
          Expanded(
            child: StreamBuilder(
              stream: _chatProvider.streamChatRooms(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No chat rooms available.'));
                }

                final chatRooms = snapshot.data!.docs;
                List<ChatItem> chatItemWidgets = [];

                for (var room in chatRooms) {
                  final roomDoc = ChatRoom.fromDocumentSnapshot(room);
                  final chatItem = ChatItem(
                    key: ValueKey(room.id),
                    chatRoom: roomDoc,
                  );
                  chatItemWidgets.add(chatItem);
                }

                return CustomScrollView(
                  slivers: <Widget>[
                    CupertinoSliverRefreshControl(
                      onRefresh: _refreshChatRooms,
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return chatItemWidgets[index];
                        },
                        childCount: chatItemWidgets.length,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateTo(context, const CreateChatScreen(), TransitionType.slideUp);
          // _createRandomChatRoom();
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(CupertinoIcons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
