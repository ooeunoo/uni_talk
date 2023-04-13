import 'package:flutter/material.dart';

class CustomTheme {
  final ThemeData themeData;

  // chating room
  final IconThemeData chatRoomAppBarIcon;
  final TextStyle chatRoomAppBarTitle;
  final TextStyle chatRoomAppBarSubTitle;
  final TextStyle chatRoomMessageTextField;
  final InputDecoration chatRoomMessageHintTextField;

  CustomTheme(
      {required this.themeData,
      required this.chatRoomAppBarIcon,
      required this.chatRoomAppBarTitle,
      required this.chatRoomAppBarSubTitle,
      required this.chatRoomMessageTextField,
      required this.chatRoomMessageHintTextField});
}
