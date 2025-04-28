import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chat_controller.dart';
import '../widgets/chat_widget.dart';


class GeminiChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeminiChatController>(
      init: GeminiChatController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: Text('Food Chatbot')),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    return GeminiChatMessageWidget(
                      text: msg['text']!,
                      isUser: msg['sender'] == 'user',
                    );
                  },
                ),
              ),
              if (controller.isLoading)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.controller,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: controller.isLoading
                          ? null
                          : () {
                        String text = controller.controller.text.trim();
                        if (text.isNotEmpty) {
                          controller.controller.clear();
                          controller.sendMessage(text);
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
