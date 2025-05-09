import 'package:flutter/material.dart';

class ExerciseWidget extends StatelessWidget {
  final Map<String, dynamic> exercises;

  const ExerciseWidget({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
    final questions = exercises['questions'] as List<dynamic>?;

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
              // Exercise Header
              Semantics(
                header: true,
                child: Text(
                  "Exercises",
                  style: TextStyle(
                    fontSize: 28, // Larger text for accessibility
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // High contrast
                    letterSpacing: 1.2, // Premium typography
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Display Questions
              if (questions != null && questions.isNotEmpty)
                ...questions.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final question = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question Text
                        Semantics(
                          child: Text(
                            "Q$index: ${question['question']}",
                            style: TextStyle(
                              fontSize: 24, // Larger text for accessibility
                              fontWeight: FontWeight.w500,
                              color: Colors.black, // High contrast
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Display Options (if available)
                        if (question['options'] != null)
                          ...question['options']
                              .map<Widget>((option) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6.0),
                                    child: Semantics(
                                      button: true,
                                      child: Text(
                                        "- $option",
                                        style: TextStyle(
                                          fontSize:
                                              20, // Larger text for accessibility
                                          color:
                                              Colors.black87, // High contrast
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        const SizedBox(height: 12),
                        // Display Answer (if available)
                        if (question['answer'] != null)
                          Semantics(
                            child: Text(
                              "Answer: ${question['answer']}",
                              style: TextStyle(
                                fontSize: 20, // Larger text for accessibility
                                fontStyle: FontStyle.italic,
                                color: Colors
                                    .black54, // Slightly muted for contrast
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              // Fallback for No Questions
              if (questions == null || questions.isEmpty)
                Text(
                  "No exercises available for this chapter.",
                  style: TextStyle(
                    fontSize: 24, // Larger text for accessibility
                    fontWeight: FontWeight.w400,
                    color: Colors.black87, // High contrast
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
