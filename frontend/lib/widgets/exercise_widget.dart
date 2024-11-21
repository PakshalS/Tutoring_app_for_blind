import 'package:flutter/material.dart';

class ExerciseWidget extends StatelessWidget {
  final Map<String, dynamic> exercises;

  const ExerciseWidget({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
    final questions = exercises['questions'] as List<dynamic>?;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Exercises",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (questions != null)
              ...questions.map((question) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text("- Q: ${question['question']}"),
                );
              }),
          ],
        ),
      ),
    );
  }
}
