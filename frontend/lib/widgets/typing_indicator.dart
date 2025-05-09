import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(
          vertical: 8, horizontal: 16), // Consistent spacing
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(16), // Increased padding
            decoration: BoxDecoration(
              color: Colors.black87, // Dark background for contrast
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
              "Typing...",
              style: TextStyle(
                fontSize: 20, // Larger text for accessibility
                color: Colors.yellow[700], // High contrast
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
