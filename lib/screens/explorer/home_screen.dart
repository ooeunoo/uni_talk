import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uni_talk/models/virtual_user.dart';
import 'package:uni_talk/providers/virtual_user_provider.dart';
import 'package:uni_talk/screens/chat/widgets/virtual_user_card.dart';

class ExplorerHomeScreen extends StatefulWidget {
  const ExplorerHomeScreen({super.key});

  @override
  State<ExplorerHomeScreen> createState() => _ExplorerHomeScreenState();
}

class _ExplorerHomeScreenState extends State<ExplorerHomeScreen> {
  final VirtualUserProvider virtualUserProvider = VirtualUserProvider();
  final List<VirtualUser> users = [];
  int limit = 10;
  late StreamSubscription<List<VirtualUser>> subscription;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void _fetchUsers() {
    subscription =
        virtualUserProvider.getUsers(limit: limit).listen((newUsers) {
      if (mounted) {
        setState(() {
          users.addAll(newUsers);
        });
      }
    });
  }

  void fetchMoreUsers() {
    setState(() {
      limit += 10;
    });
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    const int crossAxisCount = 2;
    final double itemWidth = MediaQuery.of(context).size.width / 2;
    const double itemHeight = 280.0;
    final double aspectRatio = itemWidth / itemHeight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount, // Use the _crossAxisCount variable
          childAspectRatio: aspectRatio, // Use the calculated aspect ratio
        ),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return VirtualUserCard(user: user);
        },
      ),
    );
  }
}
