import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/models/virtual_user.dart';
import 'package:uni_talk/providers/chat_provider.dart';
import 'package:uni_talk/providers/virtual_user_provider.dart';
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

  final ChatProvider chatProvider = ChatProvider();
  final VirtualUserProvider virtualUserProvider = VirtualUserProvider();

  final List<String> categories = [
    'ALL',
    'Personal',
    'Accorions',
    'Icons',
    'ABC'
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshChatRooms() async {
    setState(() {});
  }

  Future<VirtualUser?> getVirtualUser(String virtualUserId) async {
    return virtualUserProvider.getVirtualUser(virtualUserId);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double bannerHeight = screenHeight * 0.1;
    double categoryHeight = screenHeight * 0.05;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 30),
            child: Text("채팅",
                style: TextStyle(
                    color: CupertinoColors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold))),
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
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: categoryHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                String category = categories[index];
                bool isSelected = category == selectedCategory;
                return InkResponse(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? theme.primaryColor : Colors.grey,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: bannerHeight),

          // Chat list
          Expanded(
            child: StreamBuilder(
              stream: chatProvider.streamChatRooms(),
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
                      getVirtualUser: (virtualUserId) =>
                          getVirtualUser(virtualUserId));
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
