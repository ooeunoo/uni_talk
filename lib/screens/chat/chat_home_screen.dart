import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_talk/config/chat.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/models/virtual_user.dart';
import 'package:uni_talk/providers/chat_provider.dart';
import 'package:uni_talk/providers/user_provider.dart';
import 'package:uni_talk/providers/virtual_user_provider.dart';
import 'package:uni_talk/screens/chat/search_screen.dart';
import 'package:uni_talk/screens/chat/widgets/chat_item.dart';
import 'package:uni_talk/utils/navigate.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  String selectedCategory = 'All';

  final UserProvider _userProvider = UserProvider();
  final ChatProvider _chatProvider = ChatProvider();
  final VirtualUserProvider _virtualUserProvider = VirtualUserProvider();
  final TextEditingController _titleTextController = TextEditingController();

  final List<String> categories = [
    'All',
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshChatRooms() async {
    setState(() {});
  }

  Future<VirtualUser?> getVirtualUser(String virtualUserId) async {
    return _virtualUserProvider.getVirtualUser(virtualUserId);
  }

  Future<bool> createChatRoom(String title) async {
    User? user = _userProvider.currentUser;
    if (user == null) {
      return false;
    }

    ChatRoom chatRoom = ChatRoom(
      userId: user.uid,
      title: title,
      type: ChatRoomType.personal,
      image: 'https://source.unsplash.com/random/640x480', // 랜덤 이미지 URL 생성
    );

    await _chatProvider.createChatRoom(chatRoom);
    return true;
  }

  void _showCreateChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 채팅방'),
        content: TextField(
          controller: _titleTextController,
          decoration: const InputDecoration(
            hintText: '',
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              bool success = await createChatRoom(_titleTextController.text);

              if (success) {
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double bannerHeight = screenHeight * 0.1;
    double categoryHeight = screenHeight * 0.03;

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
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.search),
                    onPressed: () {
                      navigateTo(context, const SearchScreen(),
                          TransitionType.slideLeft);
                    },
                  ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.add),
                    onPressed: () {
                      _showCreateChatDialog(context);
                    },
                  ),
                ],
              )),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          // SizedBox(
          //   height: categoryHeight,
          //   child: ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     itemCount: categories.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       String category = categories[index];
          //       bool isSelected = category == selectedCategory;
          //       return InkResponse(
          //         onTap: () {
          //           setState(() {
          //             selectedCategory = category;
          //           });
          //         },
          //         child: Container(
          //           padding: const EdgeInsets.symmetric(horizontal: 20),
          //           child: Text(
          //             category,
          //             style: TextStyle(
          //               color: isSelected ? theme.primaryColor : Colors.grey,
          //               fontWeight:
          //                   isSelected ? FontWeight.bold : FontWeight.normal,
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),

          // Chat list
          Expanded(
            child: StreamBuilder(
              stream: _chatProvider.streamChatRooms(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<ChatItem> chatItemWidgets = [];

                // if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {}

                final chatRooms = snapshot.data!.docs;

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
                    // SliverToBoxAdapter(
                    //     child: GoogleBanner(height: bannerHeight)),
                    // const SliverToBoxAdapter(
                    //     child: SizedBox(
                    //   height: 10,
                    // )),
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
    );
  }
}
