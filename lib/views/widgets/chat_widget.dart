import 'package:flutter/material.dart';

class FoodChatMessageWidget extends StatelessWidget {
  final String text;
  final bool isUser;

  const FoodChatMessageWidget({
    Key? key,
    required this.text,
    required this.isUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
        constraints: BoxConstraints(
        maxWidth: 300, // The borders are not fixed like WhatsApp
    ),
    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
    decoration: BoxDecoration(
    color: isUser ? Colors.green.shade200 : Colors.grey[300],
    borderRadius: BorderRadius.only(
    topLeft: Radius.circular(12),
    topRight: Radius.circular(12),
    bottomLeft: Radius.circular(isUser ? 12 : 0),
    bottomRight: Radius.circular(isUser ? 0 : 12),
    ),
    ),
    child: Text(
    text,
    style: TextStyle(fontSize: 16),
    ),)
    );
  }
}
