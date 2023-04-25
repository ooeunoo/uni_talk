import 'package:flutter/material.dart';

class GoogleBanner extends StatelessWidget {
  final double height;

  const GoogleBanner({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SizedBox(
        height: height,
        child: Container(color: Colors.yellow),
      ),
    );
  }
}
