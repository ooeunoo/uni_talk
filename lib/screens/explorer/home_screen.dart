import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:uni_talk/config/chat/category.dart';
import 'package:uni_talk/config/chat/message_sender.dart';
import 'package:uni_talk/config/chat/type.dart';
import 'package:uni_talk/config/role_chat_category.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/models/role_chat.dart';
import 'package:uni_talk/providers/chat_provider.dart';
import 'package:uni_talk/providers/role_chat_provider.dart';
import 'package:uni_talk/providers/user_provider.dart';
import 'package:uni_talk/screens/chat/role_chat_screen.dart';

class ExplorerHomeScreen extends StatefulWidget {
  const ExplorerHomeScreen({super.key});

  @override
  State<ExplorerHomeScreen> createState() => _ExplorerHomeScreenState();
}

class _ExplorerHomeScreenState extends State<ExplorerHomeScreen> {
  UserProvider userProvider = UserProvider();
  ChatProvider chatProvider = ChatProvider();
  RoleChatProvider roleChatProvider = RoleChatProvider();
  late Future<List<RoleChat>> _topSelectedRoleChats;
  Map<RoleChatCategory, List<RoleChat>> roleChatData = {};

  @override
  void initState() {
    super.initState();
    _topSelectedRoleChats = roleChatProvider.getTopSelectedRoleChats();

    // Initialize data for all categories
    for (RoleChatCategory category in RoleChatCategory.values) {
      roleChatProvider.getRoleChats(category: category).then((data) {
        setState(() {
          roleChatData[category] = data;
        });
      });
    }
  }

  Future<void> _handleRoleChatItemSelected(RoleChat role) async {
    User? user = userProvider.currentUser;

    if (user == null) {
      return;
    }

    ChatRoom? chatRoom = await chatProvider.getExistingChatRoom(
      user.uid,
      role.id!,
    );

    if (chatRoom == null) {
      chatRoom = ChatRoom(
        userId: user.uid,
        title: role.role,
        image: role.image,
        type: ChatRoomType.role,
        category: ChatRoomCategory.unknown,
        roleChatId: role.id,
        previewMessage: '',
      );
      chatRoom = await chatProvider.createChatRoom(chatRoom);

      ChatMessage chatMessage = ChatMessage(
          chatRoomId: chatRoom.id!,
          sentBy: MessageSender.chatgpt,
          message: role.welcomeMessage,
          like: false);

      await chatProvider.sendMessage(chatMessage);

      await roleChatProvider.upSelectedRoleChat(role.id!);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoleChatScreen(
          chatRoom: chatRoom!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: ListView(
        children: [
          FutureBuilder<List<RoleChat>>(
            future: _topSelectedRoleChats,
            builder:
                (BuildContext context, AsyncSnapshot<List<RoleChat>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              List<RoleChat>? topSelectedRoleChats = snapshot.data;

              return SizedBox(
                height: 250,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        topSelectedRoleChats[index].image,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  itemCount: topSelectedRoleChats!.length,
                  viewportFraction: 0.8,
                  scale: 0.9,
                  loop: true,
                  pagination: const SwiperPagination(),
                  autoplay: true,
                ),
              );
            },
          ),
          ...List.generate(
            RoleChatCategory.values.length,
            (index) {
              final category = RoleChatCategory.values[index];
              return FutureBuilder<List<RoleChat>>(
                future: roleChatProvider.getRoleChats(category: category),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('데이터를 불러오는 중 오류가 발생했습니다.');
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Text(
                            getRoleChatCategoryToKorean(category),
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 160,
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, roleIndex) {
                              final role = snapshot.data?[roleIndex];
                              if (role != null) {
                                return buildRoleTile(role);
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildRoleTile(RoleChat role) {
    return GestureDetector(
      onTap: () {
// 채팅방을 열어야 할 때 처리를 여기에 추가합니다.
        _handleRoleChatItemSelected(role);
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: role.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                role.role,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
