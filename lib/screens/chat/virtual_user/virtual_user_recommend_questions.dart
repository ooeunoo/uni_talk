import 'package:flutter/material.dart';
import 'package:uni_talk/models/virtual_user.dart';

class VirtualUserRecommendQuestions extends StatelessWidget {
  final TextEditingController msgController;
  final Future<void> Function(VirtualUser virtualUser, String message)
      startConversation;
  final List<String> randomQuestions;
  final VirtualUser virtualUser;

  const VirtualUserRecommendQuestions({
    super.key,
    required this.msgController,
    required this.startConversation,
    required this.randomQuestions,
    required this.virtualUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  '추천 질문 ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: <Widget>[
                  ...randomQuestions.map(
                    (question) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      elevation: 5.0,
                      child: InkWell(
                        onTap: () => startConversation(virtualUser, question),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          child: Text(
                            question,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
