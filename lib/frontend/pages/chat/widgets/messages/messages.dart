import 'package:flutter/material.dart';

class TypeText extends StatelessWidget {
  final Map<String, dynamic> currentMessage;
  final String userId;

  const TypeText({Key? key, required this.currentMessage, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(30),
          bottomLeft: currentMessage['senderId'] != userId  ? const Radius.circular(0) : const Radius.circular(30),
          topRight: const Radius.circular(30),
          bottomRight: currentMessage['senderId'] != userId  ? const Radius.circular(30) : const Radius.circular(0),
        ),
        color: (currentMessage['senderId'] != userId ? const Color(0xFF505050) : Colors.white),
      ),
      padding: const EdgeInsets.all(15),
      child: Text(currentMessage[currentMessage['senderId'] != userId ? 'assistantMessage' : 'userMessage'], style: TextStyle(fontSize: 15, color: currentMessage['senderId'] != userId ? Colors.white : Colors.black)),
    );
  }
}