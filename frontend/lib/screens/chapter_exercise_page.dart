import 'package:flutter/material.dart';
import '../widgets/mcq_widget.dart';
import 'review_questions_page.dart';

class ChapterExercisePage extends StatefulWidget {
  final Map<String, dynamic> exercises;

  const ChapterExercisePage({super.key, required this.exercises});

  @override
  _ChapterExercisePageState createState() => _ChapterExercisePageState();
}

class _ChapterExercisePageState extends State<ChapterExercisePage> {
  int currentQuestionIndex = 0;
  int correctAnswers = 0; // Counter for correct answers
  int incorrectAnswers = 0; // Counter for incorrect answers
  List<Map<String, dynamic>> results =
      []; // Store question, user answer, and correctness

  void handleAnswer(bool isCorrect, String userAnswer) {
    final questionData = widget.exercises['questions'][currentQuestionIndex];

    // Save the result
    results.add({
      'question': questionData['question'],
      'correctAnswer': questionData['answer'],
      'userAnswer': userAnswer,
      'isCorrect': isCorrect,
    });

    setState(() {
      if (isCorrect) {
        correctAnswers++; // Increment correct answers
      } else {
        incorrectAnswers++; // Increment incorrect answers
      }

      // Move to the next question or show the review page
      if (currentQuestionIndex < widget.exercises['questions'].length - 1) {
        currentQuestionIndex++;
      } else {
        navigateToReviewPage();
      }
    });
  }

  void navigateToReviewPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewQuestionsPage(
          results: results,
          correctAnswers: correctAnswers,
          incorrectAnswers: incorrectAnswers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.exercises['questions'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercises"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Current Question
              MCQWidget(
                questionData: questions[currentQuestionIndex],
                onAnswerSubmitted: handleAnswer,
              ),

              // Display Current Score
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "Correct: $correctAnswers, Incorrect: $incorrectAnswers",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
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
