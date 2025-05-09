import 'package:flutter/material.dart';
import '../models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300), // Added required duration
      margin: const EdgeInsets.symmetric(
          vertical: 8, horizontal: 16), // Increased spacing
      child: Align(
        alignment:
            message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(16), // Increased padding
          constraints: const BoxConstraints(
              maxWidth: 320), // Slightly wider for readability
          decoration: BoxDecoration(
            color: message.isUser
                ? Colors.yellow[700]
                : Colors.black87, // High contrast
            borderRadius: BorderRadius.circular(16), // Rounded edges
            boxShadow: [
              BoxShadow(
                color: Colors.yellow[300]!.withOpacity(0.3), // Subtle glow
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            message.text,
            style: TextStyle(
              fontSize: 22, // Larger text for accessibility
              color: message.isUser
                  ? Colors.black
                  : Colors.yellow[700], // High contrast
              height: 1.5, // Improved line spacing
            ),
          ),
        ),
      ),
    );
  }
}
