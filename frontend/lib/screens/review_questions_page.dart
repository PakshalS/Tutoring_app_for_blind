import 'package:flutter/material.dart';
import '../widgets/voice_wrapper.dart';

class ReviewQuestionsPage extends StatelessWidget {
  final List<Map<String, dynamic>> results;
  final int correctAnswers;
  final int incorrectAnswers;

  const ReviewQuestionsPage({
    super.key,
    required this.results,
    required this.correctAnswers,
    required this.incorrectAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return VoiceWrapper(
      child: Scaffold(
        backgroundColor: Colors.black, // High-contrast black background
        appBar: AppBar(
          backgroundColor: Colors.yellow[700], // Bright yellow for contrast
          title: const Text(
            "Review Questions",
            style: TextStyle(
              fontSize: 30, // Larger text for accessibility
              fontWeight: FontWeight.bold,
              color: Colors.black, // High contrast with app bar background
              letterSpacing: 1.2, // Premium typography
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.all(24.0), // Increased padding for clarity
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Center content
              children: [
                // Display Correct and Incorrect Counts
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    "Correct: $correctAnswers, Incorrect: $incorrectAnswers",
                    textAlign: TextAlign.center, // Center for visibility
                    style: TextStyle(
                      fontSize: 28, // Larger text for accessibility
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow[700], // High contrast
                      letterSpacing: 1.2, // Premium typography
                    ),
                  ),
                ),
                const SizedBox(height: 30), // Ample spacing to avoid clutter
                // Display all questions with user answers
                ...results.asMap().entries.map((entry) {
                  final index = entry.key;
                  final result = entry.value;
                  final question = result['question'];
                  final correctAnswer = result['correctAnswer'];
                  final userAnswer = result['userAnswer'];
                  final isCorrect = result['isCorrect'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0), // Increased spacing
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: Card(
                        elevation: 8.0, // Increased shadow for premium feel
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16.0), // Rounded edges
                        ),
                        color: Colors.yellow[700], // Bright yellow for contrast
                        child: Padding(
                          padding: const EdgeInsets.all(20.0), // Larger padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Question ${index + 1}: $question",
                                style: TextStyle(
                                  fontSize: 24, // Larger text for accessibility
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // High contrast
                                  letterSpacing: 1.0, // Premium typography
                                ),
                              ),
                              const SizedBox(height: 12), // Spacing for clarity
                              Text(
                                "Your Answer: $userAnswer",
                                style: TextStyle(
                                  fontSize: 20, // Larger text for accessibility
                                  color: isCorrect
                                      ? Colors.green[700]
                                      : Colors
                                          .red[700], // High contrast feedback
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Correct Answer: $correctAnswer",
                                style: TextStyle(
                                  fontSize: 20, // Larger text for accessibility
                                  color: Colors
                                      .black87, // Slightly muted for hierarchy
                                  fontStyle: FontStyle
                                      .italic, // Differentiate correct answer
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
