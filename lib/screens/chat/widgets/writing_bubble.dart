import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WrittingBubble extends StatefulWidget {
  const WrittingBubble({super.key});

  @override
  State<WrittingBubble> createState() => _WrittingBubbleState();
}

class _WrittingBubbleState extends State<WrittingBubble> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bool isUser = chatMessage.sentBy == MessageSender.user;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              '',
              style: TextStyle(
                  fontSize: 13, fontFamily: 'Poppins', color: Colors.black87),
            ),
          ),
          Material(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              topLeft: Radius.circular(0),
              bottomRight: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            color: Colors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: DefaultTextStyle(
                style: const TextStyle(
                    fontSize: 15.0, fontFamily: 'Poppins', color: Colors.black),
                child: AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText('• • •'),
                  ],
                  isRepeatingAnimation: true,
                  onTap: () {
                    print("Tap Event");
                  },
                ),
              ),

              //    Text(
              //     chatMessage.message,
              //     style: TextStyle(
              //       color: isUser ? Colors.white : Colors.blue,
              //       fontFamily: 'Poppins',
              //       fontSize: 15,
              //     ),
              //   ),
            ),
          ),
        ],
      ),
    );
  }
}
