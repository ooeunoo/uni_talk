import 'package:flutter/foundation.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/services/openai_service.dart';

class OpenAIProvider with ChangeNotifier {
  final OpenAIService _openaiService = OpenAIService();

  Future<String> askToChatGPT(
      List<ChatMessage> prevMessages, String prompt) async {
    return _openaiService.askToChatGPT(prevMessages, prompt);
  }
}
