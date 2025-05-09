import 'package:flutter/material.dart';
import '../widgets/mcq_widget.dart';
import 'review_questions_page.dart';
import '../services/current_location_service.dart';
import '../widgets/voice_wrapper.dart';

class ChapterExercisePage extends StatefulWidget {
  final Map<String, dynamic> exercises;
  final String chapterName;

  const ChapterExercisePage({
    super.key,
    required this.exercises,
    required this.chapterName,
  });

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

  @override
  void initState() {
    super.initState();
    CurrentLocationService.setPage('exercise', chapter: widget.chapterName);
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

    return VoiceWrapper(
      child: Scaffold(
        backgroundColor: Colors.black, // High-contrast black background
        appBar: AppBar(
          backgroundColor: Colors.yellow[700], // Bright yellow for contrast
          title: const Text(
            "Exercises",
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
            padding: const EdgeInsets.all(24.0), // Increased padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Center content
              children: [
                // Display Current Question
                MCQWidget(
                  questionData: questions[currentQuestionIndex],
                  onAnswerSubmitted: handleAnswer,
                ),
                // Display Current Score
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      "Correct: $correctAnswers, Incorrect: $incorrectAnswers",
                      style: TextStyle(
                        fontSize: 24, // Larger text for accessibility
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow[700], // High contrast
                        letterSpacing: 1.2, // Premium typography
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
