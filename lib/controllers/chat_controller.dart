import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodChatbotController extends GetxController {
  final TextEditingController controller = TextEditingController();
  List<Map<String, String>> messages = [];
  bool isLoading = false;

  static const String apiKey = "AIzaSyCKCDFsRTF9yrZZJ9y_vgHsKAbcD1ekLzw";
  static const String apiUrl = "https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash:generateContent?key=$apiKey";

  Future<void> sendMessage(String userMessage) async {
    messages.add({"sender": "user", "text": userMessage});
    isLoading = true;
    update();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": "انت مساعد متخصص في الأكل فقط. تجاوب على الأسئلة اللي ليها علاقة بالأكل أو التغذية سواء بالعربي أو بالانجليزي. لو السؤال مش عن الأكل قول انك متخصص أكل بس.\n\nYou are a food assistant. Answer only food-related or nutrition questions, in the same language of the user message.\n\nالسؤال: $userMessage"


                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String botReply = data["candidates"][0]["content"]["parts"][0]["text"];
        messages.add({"sender": "bot", "text": botReply});
      } else {
        messages.add({"sender": "bot", "text": "Error: ${response.statusCode}"});
      }
    } catch (e) {
      messages.add({"sender": "bot", "text": "Failed to connect to API"});
    } finally {
      isLoading = false;
      update();
    }
  }
}
