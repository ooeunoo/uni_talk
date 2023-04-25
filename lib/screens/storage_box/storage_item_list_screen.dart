import 'package:flutter/material.dart';
import 'package:uni_talk/config/theme.dart';
import 'package:uni_talk/models/custom_theme.dart';
import 'package:uni_talk/models/storage_box.dart';

class StorageItemListScreen extends StatefulWidget {
  final StorageBox storageBox;

  const StorageItemListScreen({super.key, required this.storageBox});

  @override
  State<StorageItemListScreen> createState() => _StorageItemListScreenState();
}

class _StorageItemListScreenState extends State<StorageItemListScreen> {
  late StorageBox storageBox;

  @override
  void initState() {
    storageBox = widget.storageBox;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CustomTheme theme = getThemeData(Theme.of(context).brightness);

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 50) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          iconTheme: theme.chatRoomAppBarIcon,
          elevation: 0,
          title: Text(
            storageBox.title.length > 10
                ? '${storageBox.title.substring(0, 10)} ∙∙∙'
                : storageBox.title,
            overflow: TextOverflow.clip,
            style: theme.chatRoomAppBarTitle,
          ),
          centerTitle: true,
        ),
      ),
    );
  }
}
