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

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Question
            Text(
              question,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

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
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }).toList(),

            const SizedBox(height: 10),

            // Submit Button
            ElevatedButton(
              onPressed: selectedAnswer != null
                  ? () {
                      final isCorrect = selectedAnswer == correctAnswer;
                      widget.onAnswerSubmitted(isCorrect, selectedAnswer!);
                    }
                  : null,
              child: const Text("Submit Answer"),
            ),
          ],
        ),
      ),
    );
  }
}
