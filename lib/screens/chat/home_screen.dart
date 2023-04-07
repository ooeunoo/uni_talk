import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_talk/screens/chat/widgets/chat_item.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  String selectedCategory = 'ALL';

  @override
  final List<String> categories = [
    'ALL',
    'Personal',
    'Accorions',
    'Icons',
  ]; // the list of categories

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double categoryHeight = screenHeight * 0.05;
    double chatListHeight = screenHeight * 9.5;

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
            const Text('App Title'),
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
            child: ListView.builder(
              itemCount: 20, // replace with the actual number of chats
              itemBuilder: (BuildContext context, int index) {
                return const ChatItem();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 클릭시 실행될 동작을 여기에 작성합니다.
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
