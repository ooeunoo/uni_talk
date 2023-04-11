import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_talk/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    User? user = userProvider.currentUser;

    return Scaffold(
        appBar: AppBar(elevation: 0),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user?.photoURL ??
                        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
                    radius: 50,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.displayName ?? 'Anonymous',
                          style: const TextStyle(fontSize: 24)),
                      const SizedBox(
                        height: 8,
                      ),
                      // _buildAuthProviderChip(user),
                    ],
                  )
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('로그아웃하기'),
                  onPressed: () async {
                    await userProvider.signOut();
                  },
                ),
              )
            ],
          ),
        ));
  }

  // Widget _buildAuthProviderChip(User? user) {
  //   if (user == null) {
  //     return const Chip(
  //       avatar: Icon(Icons.person),
  //       label: Text(''),
  //     );
  //   }
  //   String providerName = user.providerData[0].providerId.split('.').first;
  //   IconData providerIcon;

  //   switch (providerName) {
  //     case 'google':
  //       providerIcon = Icons.login_outlined;
  //       break;
  //     case 'kakao':
  //       providerIcon = Icons.login_outlined; // 카카오의 공식 아이콘이 없음
  //       break;
  //     case 'apple':
  //       providerIcon = Icons.login_outlined; // 애플의 공식 아이콘이 없음
  //       break;
  //     default:
  //       providerIcon = Icons.person;
  //   }

  //   return Chip(
  //     avatar: Icon(providerIcon),
  //     label: Text(providerName),
  //   );
  // }
}
