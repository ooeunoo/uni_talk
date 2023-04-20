import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uni_talk/config/chat.dart';
import 'package:uni_talk/config/openai_model.dart';
import 'package:uni_talk/models/chat_message.dart';

class OpenAIService {
  static const String apiKey =
      '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';
  static const String apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String?> askToChatGPTForPersonal(
      List<ChatMessage> prevMessages, String prompt) async {
    try {
      List<Map<String, String>> formattedPrevMessages = [];

      for (ChatMessage prevMessage in prevMessages.reversed) {
        formattedPrevMessages.add({
          "role":
              prevMessage.sentBy == MessageSender.user ? "user" : "assistant",
          "content": prevMessage.message,
        });
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: utf8.encode(json.encode({
          "model": getOepnAIModel(OpenAIModel.gpt3_5_turbo),
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            ...formattedPrevMessages,
            {"role": "user", "content": prompt}
          ]
        })),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final choices = data['choices'];
        if (choices != null && choices.isNotEmpty) {
          return choices[0]['message']['content'].toString().trim();
        } else {
          print('askToChatGPTForPersonal ${response.body}');
          return null;
        }
      } else {
        print('askToChatGPTForPersonal ${response.body}');
        return null;
      }
    } catch (e) {
      print('askToChatGPTForPersonal $e');
      return null;
    }
  }

  Future<String?> askToChatGPTForRole(String? systemMessage,
      List<ChatMessage> prevMessages, String prompt) async {
    try {
      List<Map<String, String>> formattedPrevMessages = [];
      for (ChatMessage prevMessage in prevMessages.reversed) {
        formattedPrevMessages.add({
          "role":
              prevMessage.sentBy == MessageSender.user ? "user" : "assistant",
          "content": prevMessage.message,
        });
      }

      print(systemMessage);
      Map<String, dynamic> body = {
        "model": getOepnAIModel(OpenAIModel.gpt3_5_turbo),
        "messages": [
          {"role": "system", "content": systemMessage},
          ...formattedPrevMessages,
          {"role": "user", "content": prompt}
        ]
      };
      JsonEncoder encoder = const JsonEncoder.withIndent(
        '  ',
      );
      String prettyBody = encoder.convert(body);
      debugPrint(prettyBody);

      // // Debug prevMessages using printLongString
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: utf8.encode(json.encode(body)),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final choices = data['choices'];
        if (choices != null && choices.isNotEmpty) {
          return choices[0]['message']['content'].toString().trim();
        } else {
          print('askToChatGPTForRole ${response.body}');

          return null;
        }
      } else {
        print('askToChatGPTForRole ${response.body}');
        return null;
      }
    } catch (e) {
      print('askToChatGPTForRole $e');
      return null;
    }
  }
}
