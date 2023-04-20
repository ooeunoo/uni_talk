import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni_talk/models/chat_room.dart';
import 'package:uni_talk/screens/chat/chat_screen.dart';
import 'package:uni_talk/utils/navigate.dart';

class ChatItem extends StatelessWidget {
  final ChatRoom chatRoom;

  const ChatItem({
    super.key,
    required this.chatRoom,
  });

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

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: () {
        bool isRoleChat = chatRoom.roleChatId == null ? false : true;

        if (isRoleChat) {
          // navigateTo(
          //     context,
          //     RoleChatScreen(
          //       key: ValueKey(chatRoom.id),
          //       chatRoom: chatRoom,
          //     ),
          //     TransitionType.slideLeft);
        } else {
          navigateTo(
              context,
              ChatScreen(
                key: ValueKey(chatRoom.id),
                chatRoom: chatRoom,
              ),
              TransitionType.slideLeft);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            if (chatRoom.image != null && chatRoom.image!.isNotEmpty)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(chatRoom.image!),
                    fit: BoxFit.cover,
                  ),
                ),
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
