import 'package:flutter/material.dart';

class ExerciseWidget extends StatelessWidget {
  final Map<String, dynamic> exercises;

  const ExerciseWidget({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
    final questions = exercises['questions'] as List<dynamic>?;

    return Card(
      elevation: 4.0, // Adds shadow for better visibility
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.white, // Background color
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise Header
            Semantics(
              header: true,
              child: const Text(
                "Exercises",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Display Questions
            if (questions != null && questions.isNotEmpty)
              ...questions.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final question = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question Text
                      Semantics(
                        child: Text(
                          "Q$index: ${question['question']}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Display Options (if available)
                      if (question['options'] != null)
                        ...question['options']
                            .map<Widget>((option) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Semantics(
                                    button: true,
                                    child: Text(
                                      "- $option",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),

                      const SizedBox(height: 8),

                      // Display Answer (if available)
                      if (question['answer'] != null)
                        Semantics(
                          child: Text(
                            "Answer: ${question['answer']}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),

            // Fallback for No Questions
            if (questions == null || questions.isEmpty)
              const Text(
                "No exercises available for this chapter.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
