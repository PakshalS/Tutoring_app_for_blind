import 'package:flutter/material.dart';

class MCQWidget extends StatefulWidget {
  final Map<String, dynamic> questionData;
  final Function(bool, String) onAnswerSubmitted;

  const MCQWidget({
    super.key,
    required this.questionData,
    required this.onAnswerSubmitted,
  });

  @override
  _MCQWidgetState createState() => _MCQWidgetState();
}

class _MCQWidgetState extends State<MCQWidget> {
  String? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    final question = widget.questionData['question'];
    final options = widget.questionData['options'] as List<dynamic>;
    final correctAnswer = widget.questionData['answer'];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Card(
        elevation: 8.0, // Increased shadow for premium feel
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // Rounded edges
        ),
        color: Colors.yellow[700], // Bright yellow for contrast
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Larger padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Question
              Text(
                question,
                style: TextStyle(
                  fontSize: 26, // Larger text for accessibility
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // High contrast
                  letterSpacing: 1.2, // Premium typography
                ),
              ),
              const SizedBox(height: 20),
              // Display Options
              ...options.map((option) {
                return RadioListTile<String>(
                  value: option,
                  groupValue: selectedAnswer,
                  onChanged: (value) {
                    setState(() {
                      selectedAnswer = value;
                    });
                  },
                  title: Text(
                    option,
                    style: TextStyle(
                      fontSize: 22, // Larger text for accessibility
                      color: Colors.black87, // High contrast
                      letterSpacing: 1.0,
                    ),
                  ),
                  activeColor: Colors.black, // High contrast for selected state
                );
              }),
              const SizedBox(height: 20),
              // Submit Button
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Black button for contrast
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40), // Larger touch area
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // Rounded edges
                    ),
                    elevation: 8, // Shadow for premium feel
                    shadowColor:
                        Colors.yellow[300]!.withOpacity(0.5), // Glow effect
                  ),
                  onPressed: selectedAnswer != null
                      ? () {
                          final isCorrect = selectedAnswer == correctAnswer;
                          widget.onAnswerSubmitted(isCorrect, selectedAnswer!);
                        }
                      : null,
                  child: const Text(
                    "Submit Answer",
                    style: TextStyle(
                      fontSize: 24, // Large text for accessibility
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow, // High contrast
                      letterSpacing: 1.2, // Premium typography
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
