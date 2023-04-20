import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni_talk/config/chat.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/models/virtual_user.dart';
import 'package:uni_talk/screens/chat/chat_screen.dart';
import 'package:uni_talk/utils/navigate.dart';

class ChatItem extends StatelessWidget {
  final ChatRoom chatRoom;
  final Future<VirtualUser?> Function(String virtualUserId) getVirtualUser;

  const ChatItem(
      {super.key, required this.chatRoom, required this.getVirtualUser});

  String getChatTime() {
    DateFormat timeFormat = DateFormat('hh:mm'); // 시간 포맷 변경

    String lastMessageTime = timeFormat.format(chatRoom.modifiedTime!.toDate());

    // 지난 시간을 계산하는 로직 추가
    DateTime now = DateTime.now();
    DateTime messageTime = chatRoom.modifiedTime!.toDate();
    int daysAgo = now.difference(messageTime).inDays;

    String displayTime = '';
    if (daysAgo == 0) {
      // 오늘
      displayTime = lastMessageTime;
    } else if (daysAgo == 1) {
      // 어제
      displayTime = 'Yesterday';
    } else {
      // n일 전
      displayTime = '$daysAgo days ago';
    }
    return displayTime;
  }

  Future<DecorationImage> _getImage() async {
    print(chatRoom.type);
    print('here');
    print(ChatRoomType.virtualUser);
    if (chatRoom.type == ChatRoomType.virtualUser) {
      print('여기');
      final virtualUser = await getVirtualUser(chatRoom.virtualUserId!);
      print(virtualUser?.profileImage);
      return DecorationImage(
        image: NetworkImage(virtualUser?.profileImage ?? ''),
        fit: BoxFit.cover,
      );
    } else {
      return DecorationImage(
        image: NetworkImage(chatRoom.image ?? ''),
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: () {
        switch (chatRoom.type) {
          case ChatRoomType.personal:
            navigateTo(
                context,
                ChatScreen(
                  key: ValueKey(chatRoom.id),
                  chatRoom: chatRoom,
                ),
                TransitionType.slideLeft);
            break;

          case ChatRoomType.virtualUser:
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            FutureBuilder<DecorationImage>(
              future: _getImage(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: snapshot.data,
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                      chatRoom.title,
                      style: theme.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Text(
                    chatRoom.previewMessage ?? 'No messages yet',
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                getChatTime(),
                style: theme.textTheme.bodySmall,
              ),
            )
          ],
        ),
      ),
    );
  }
}
