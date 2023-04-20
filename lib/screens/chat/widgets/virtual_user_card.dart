import 'package:flutter/material.dart';
import 'package:uni_talk/models/virtual_user.dart';

class VirtualUserCard extends StatelessWidget {
  final VirtualUser user;

  const VirtualUserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  user.profileImage,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.profileId,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Expanded(
                  child: SizedBox.shrink()), // Keep the Expanded widget
              ElevatedButton(
                onPressed: () {
                  // Navigate to the chat screen
                },
                child: const Text('채팅하러가기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
