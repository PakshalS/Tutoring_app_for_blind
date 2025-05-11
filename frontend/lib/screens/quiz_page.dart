import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/current_location_service.dart';
import 'quiz_review_page.dart';
import '../widgets/quiz_mcq_widget.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Map<String, dynamic>> questions = [];
  List<String?> userAnswers = List.filled(30, null);
  List<Map<String, dynamic>> results = [];

  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  int timeLeft = 1500; // 25 minutes in seconds

  Timer? timer;

  @override
  void initState() {
    super.initState();
    CurrentLocationService.setPage('quiz');

    // Show confirmation dialog after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showStartConfirmation();
    });
  }

  Future<void> _showStartConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Ready to Start the Quiz?"),
        content: const Text(
          "You will get 30 questions and 10 minutes to complete the quiz.\n\n"
          "Press 'Yes, Start' to begin or 'No' to go back to home.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes, Start"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _fetchRandomQuestions();
    } else {
      Navigator.pop(context); // Exit back to previous screen
    }
  }

  Future<void> _fetchRandomQuestions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('subjects')
        .doc('quantitativeAptitude')
        .collection('exercises')
        .doc('exercise1')
        .get();

    final allQuestions =
        List<Map<String, dynamic>>.from(snapshot['exercise']['questions']);
    allQuestions.shuffle(Random());
    setState(() {
      questions = allQuestions.take(30).toList();
      userAnswers = List.filled(questions.length, null);
      _startTimer();
    });
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => timeLeft--);
        if (timeLeft <= 0) {
          _submitQuiz(timeUp: true);
        }
      }
    });
  }

  void _submitQuiz({bool timeUp = false}) {
    results.clear();
    correctAnswers = 0;
    incorrectAnswers = 0;

    for (int i = 0; i < questions.length; i++) {
      final userAnswer = userAnswers[i];
      final correct = userAnswer == questions[i]['answer'];

      results.add({
        'question': questions[i]['question'],
        'correctAnswer': questions[i]['answer'],
        'userAnswer': userAnswer ?? 'Unanswered',
        'isCorrect': correct,
      });

      if (correct) correctAnswers++;
      if (!correct) incorrectAnswers++;
    }

    timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizReviewPage(
          results: results,
          correctAnswers: correctAnswers,
          incorrectAnswers: incorrectAnswers,
        ),
      ),
    );
  }

  Future<bool> _confirmExit() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text('Are you sure you want to end the quiz early?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes')),
        ],
      ),
    );
    return confirm ?? false;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (timeLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (timeLeft % 60).toString().padLeft(2, '0');

    return WillPopScope(
      onWillPop: _confirmExit,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.yellow[700],
          title: Text(
            "Quiz - $minutes:$seconds",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: questions.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: Colors.yellow),
              )
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: QuizMCQWidget(
                  questionData: questions[currentQuestionIndex],
                  currentIndex: currentQuestionIndex,
                  total: questions.length,
                  selectedAnswer: userAnswers[currentQuestionIndex],
                  onAnswerSelected: (answer) => setState(() {
                    userAnswers[currentQuestionIndex] = answer;
                  }),
                  onNext: () => setState(() {
                    if (currentQuestionIndex < questions.length - 1) {
                      currentQuestionIndex++;
                    }
                  }),
                  onPrevious: () => setState(() {
                    if (currentQuestionIndex > 0) {
                      currentQuestionIndex--;
                    }
                  }),
                  onSubmit: () => _submitQuiz(),
                ),
              ),
      ),
    );
  }
}
