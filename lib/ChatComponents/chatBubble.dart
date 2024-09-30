// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? const Color.fromRGBO(143, 174, 222, 1) : Colors.white, 
        borderRadius: BorderRadius.circular(15)
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Text(message, style: const TextStyle(fontFamily: 'Outfit', fontSize: 17),),
    );
  }
}
