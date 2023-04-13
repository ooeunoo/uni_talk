import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_talk/config/chat/category.dart';
import 'package:uni_talk/config/chat/type.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/providers/chat_provider.dart';
import 'package:uni_talk/providers/user_provider.dart';
import 'package:uni_talk/screens/chat/widgets/chat_item.dart';

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
  final List<String> categories = [
    'ALL',
    'Personal',
    'Accorions',
    'Icons',
  ];

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
  }

  // TODO: delete
  void _createRandomChatRoom() {
    final faker = Faker();
    final currentUser = _userProvider.currentUser;
    if (currentUser == null) return;

    final randomChatRoom = ChatRoom(
      id: '',
      userId: currentUser.uid,
      title: faker.lorem.sentence(),
      image: 'https://source.unsplash.com/random/640x480', // 랜덤 이미지 URL 생성
      type: ChatRoomType
          .values[faker.randomGenerator.integer(ChatRoomType.values.length)],
      category: ChatRoomCategory.values[
          faker.randomGenerator.integer(ChatRoomCategory.values.length)],
    );

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.createChatRoom(randomChatRoom);
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
        toolbarHeight: 80, // AppBar의 높이를 80으로 지정
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
              onPressed: () {},
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Category list
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

          // Chat list
          Expanded(
            child: StreamBuilder<List<ChatRoomWithLastMessage>>(
              stream: _chatProvider.getChatRoomsByUserId(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ChatRoomWithLastMessage>> snapshot) {
                print(snapshot);
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error: Could not load chat rooms.'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CupertinoActivityIndicator());
                }

                List<ChatRoomWithLastMessage> chatRooms = snapshot.data!;

                return CustomScrollView(
                  slivers: [
                    CupertinoSliverRefreshControl(
                      onRefresh: _refreshChatRooms,
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          ChatRoomWithLastMessage chatRoomWithLastMessage =
                              chatRooms[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ChatItem(
                              chatRoom: chatRoomWithLastMessage.chatRoom,
                              lastMessage: chatRoomWithLastMessage.lastMessage,
                            ),
                          );
                        },
                        childCount: chatRooms.length,
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
          _createRandomChatRoom();
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(CupertinoIcons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
