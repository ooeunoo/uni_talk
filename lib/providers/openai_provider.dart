import 'package:flutter/foundation.dart';
import 'package:uni_talk/models/chat_message.dart';
import 'package:uni_talk/services/openai_service.dart';

class OpenAIProvider with ChangeNotifier {
  final OpenAIService _openaiService = OpenAIService();

  Future<String?> askToChatGPTForPersonal(
      List<ChatMessage> prevMessages, String prompt) async {
    return _openaiService.askToChatGPTForPersonal(prevMessages, prompt);
  }

  Future<String?> askToChatGPTForRole(String? systemMessage,
      List<ChatMessage> prevMessages, String prompt) async {
    return _openaiService.askToChatGPTForRole(
        systemMessage, prevMessages, prompt);
  }
}
