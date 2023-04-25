import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:uni_talk/config/chat.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/models/virtual_user.dart';
import 'package:uni_talk/providers/chat_provider.dart';
import 'package:uni_talk/providers/user_provider.dart';
import 'package:uni_talk/providers/virtual_user_provider.dart';
import 'package:uni_talk/screens/chat/virtual_user/virtual_user_chat_screen.dart';
import 'package:uni_talk/screens/explorer/widgets/virtual_user_card.dart';
import 'package:uni_talk/utils/navigate.dart';

class ExplorerHomeScreen extends StatefulWidget {
  const ExplorerHomeScreen({Key? key}) : super(key: key);

  @override
  State<ExplorerHomeScreen> createState() => _ExplorerHomeScreenState();
}

class _ExplorerHomeScreenState extends State<ExplorerHomeScreen> {
  final UserProvider userProvider = UserProvider();
  final ChatProvider chatProvider = ChatProvider();
  final VirtualUserProvider virtualUserProvider = VirtualUserProvider();

  final TextEditingController _searchController = TextEditingController();

  Future<void> handleSelected(VirtualUser virtualUser) async {
    User? user = userProvider.currentUser;

    if (user == null) {
      return;
    }

    ChatRoom? chatRoom = await chatProvider.getExistingChatRoom(user.uid,
        virtualUserId: virtualUser.id);

    if (chatRoom == null) {
      ChatRoom newChatRoom = ChatRoom(
          userId: user.uid,
          title: virtualUser.name,
          type: ChatRoomType.virtualUser,
          virtualUserId: virtualUser.id);

      chatRoom = await chatProvider.createChatRoom(newChatRoom);
      ChatMessage chatMessage = ChatMessage(
          chatRoomId: chatRoom.id!,
          sentBy: MessageSender.chatgpt,
          message: virtualUser.welcomeMessage,
          like: false);

      await chatProvider.sendMessage(chatMessage);

      await virtualUserProvider.addFollowers(virtualUser.id!);
    }

    navigateTo(context, VirtualUserChatScreen(chatRoom: chatRoom),
        TransitionType.slideLeft);
  }

  @override
  Widget build(BuildContext context) {
    const int pageSize = 10;
    const int crossAxisCount = 2;
    final double itemWidth = MediaQuery.of(context).size.width / 2;
    const double itemHeight = 250.0;
    final double aspectRatio = itemWidth / itemHeight;

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          title: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 30),
              child: Text("소셜",
                  style: TextStyle(
                      color: CupertinoColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold))),
          elevation: 0,
          centerTitle: false,
        ),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CupertinoColors.systemGrey6,
                  ),
                  child: CupertinoTextField(
                    controller: _searchController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    placeholder: 'Search',
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Icon(CupertinoIcons.search,
                          color: CupertinoColors.systemGrey),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: CupertinoColors.black,
                    ),
                    clearButtonMode: OverlayVisibilityMode.editing,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: CupertinoColors.systemGrey6,
                    ),
                    placeholderStyle:
                        const TextStyle(color: CupertinoColors.systemGrey),
                    cursorColor: CupertinoColors.black,
                    keyboardType: TextInputType.text,
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FirestoreQueryBuilder<VirtualUser>(
                    query: virtualUserProvider.getVirtualUserReferences(),
                    pageSize: pageSize,
                    builder: (context, snapshot, _) {
                      if (snapshot.isFetching) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text("Something went worng!, ${snapshot.error}");
                      } else {
                        return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: aspectRatio,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    crossAxisCount: crossAxisCount),
                            itemCount: snapshot.docs.length,
                            itemBuilder: (context, index) {
                              final hasEndReeached = snapshot.hasMore &&
                                  index + 1 == snapshot.docs.length &&
                                  !snapshot.isFetchingMore;

                              if (hasEndReeached) {
                                snapshot.fetchMore();
                              }

                              final virtualUser = snapshot.docs[index].data();
                              return VirtualUserCard(
                                key: ValueKey(virtualUser.id),
                                virtualUser: virtualUser,
                                handleSelected: (virtualUser) =>
                                    handleSelected(virtualUser),
                              );
                            });
                      }
                    },
                  )),
            )
          ],
        ));
  }
}
