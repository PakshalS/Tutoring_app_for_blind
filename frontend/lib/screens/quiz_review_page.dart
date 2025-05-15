import 'package:flutter/material.dart';

class QuizReviewPage extends StatelessWidget {
  final List<Map<String, dynamic>> results;
  final int correctAnswers;
  final int incorrectAnswers;

  const QuizReviewPage({
    super.key,
    required this.results,
    required this.correctAnswers,
    required this.incorrectAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: const Text(
          "Quiz Review",
          style: TextStyle(
            fontSize: 28,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Semantics(
              label: "Quiz Review",
              child: Text(
                "Score: $correctAnswers / ${results.length}",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.yellow[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...results.asMap().entries.map((entry) {
              final result = entry.value;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                color: Colors.yellow[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Q${entry.key + 1}: ${result['question']}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text("Your Answer: ${result['userAnswer']}",
                          style: TextStyle(
                            fontSize: 18,
                            color: result['isCorrect']
                                ? Colors.green[700]
                                : Colors.red[700],
                          )),
                      Text("Correct Answer: ${result['correctAnswer']}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              color: Colors.black)),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
