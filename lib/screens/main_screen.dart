import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_talk/screens/chat/chat_home_screen.dart';
import 'package:uni_talk/screens/profile/profile_home_screen.dart';
import 'package:uni_talk/screens/storage_box/storage_box_home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ChatHomeScreen(),
    // const ExplorerHomeScreen(),
    const StorageBoxHomeScreen(),
    const ProfileHomeScreen()
  ];

  @override
  Widget build(BuildContext context) {
    // 테마
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
        selectedIconTheme: IconThemeData(
            color: theme.bottomNavigationBarTheme.selectedItemColor),
        unselectedIconTheme: IconThemeData(
            color:
                theme.bottomNavigationBarTheme.unselectedItemColor), // 변경된 부분
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 0
                  ? CupertinoIcons.chat_bubble_fill
                  : CupertinoIcons.chat_bubble,
              size: 28,
            ),
            label: '채팅',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     _currentIndex == 1
          //         ? CupertinoIcons.square_grid_2x2_fill
          //         : CupertinoIcons.square_grid_2x2,
          //     size: 28,
          //   ),
          //   label: '소셜',
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 2
                  ? CupertinoIcons.folder_fill
                  : CupertinoIcons.folder,
              size: 28,
            ),
            label: '서랍',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 3
                  ? CupertinoIcons.person_fill
                  : CupertinoIcons.person,
              size: 28,
            ),
            label: '내정보',
          ),
        ],
      ),
    );
  }
}
