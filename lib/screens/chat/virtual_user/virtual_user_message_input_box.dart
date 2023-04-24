import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_talk/config/theme.dart';
import 'package:uni_talk/models/custom_theme.dart';
import 'package:uni_talk/models/virtual_user.dart';

class VirtualUserMessageInputBox extends StatelessWidget {
  final TextEditingController msgController;
  final Future<void> Function(VirtualUser virtualUser, String message)
      startConversation;
  final bool enable;
  final VirtualUser virtualUser;

  const VirtualUserMessageInputBox(
      {super.key,
      required this.msgController,
      required this.startConversation,
      required this.enable,
      required this.virtualUser});

  @override
  Widget build(BuildContext context) {
    CustomTheme theme = getThemeData(Theme.of(context).brightness);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Container(
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
                  padding: const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
                  child: TextField(
                    controller: msgController,
                    style: theme.chatRoomMessageTextField,
                    decoration: theme.chatRoomMessageHintTextField.copyWith(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      enabled: enable,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            IconButton(
              color: Colors.blue,
              onPressed: () =>
                  startConversation(virtualUser, msgController.text),
              icon: const Icon(
                CupertinoIcons.paperplane,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
