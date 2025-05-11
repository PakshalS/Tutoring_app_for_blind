import 'package:flutter/material.dart';
import 'package:frontend/screens/chat_screen.dart';
import 'package:frontend/screens/chapter_detail_page.dart';
import 'package:frontend/screens/chapter_list_page.dart';
import 'package:frontend/screens/home_page.dart';
import 'package:frontend/main.dart'; // to get navigatorKey
import 'package:frontend/screens/chapter_exercise_page.dart';
import '../services/firebase_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/current_location_service.dart';
import '../screens/quiz_page.dart';

class VoiceCommandService {
  final Map<String, String> chapterMap;
  final FirebaseService _firebaseService = FirebaseService();
  final FlutterTts _tts = FlutterTts();

  VoiceCommandService(this.chapterMap);

  void handleCommand(String command) {
    final cmd = command.toLowerCase();

    if (cmd.contains('where')) {
      final location = CurrentLocationService.getLocationMessage();
      _speak(location);
    } else if (cmd.contains('go to home')) {
      _speak("Navigating to Home.");
      _navigateTo(const HomePage());
    } else if (cmd.contains('go to bot') || cmd.contains('go to chat')) {
      _speak("Opening chatbot.");
      _navigateTo(const ChatScreen());
    } else if (cmd.contains('go to quiz')) {
      _speak("Opening quiz.");
      _navigateTo(const QuizPage());
    } else if (cmd.contains('go to chapter list')) {
      _speak("Opening chapter list.");
      _navigateTo(const ChapterListPage());
    } else if (cmd.contains('go to exercise of')) {
      String chapterName = cmd.replaceAll('go to exercise of', '').trim();
      _speak("Opening exercise of $chapterName");
      _navigateToExercise(chapterName);
    } else if (cmd.contains('go to')) {
      String chapterName = cmd.replaceAll('go to', '').trim();
      _speak("Opening chapter $chapterName");
      _navigateToChapter(chapterName);
    } else if (cmd.contains('go back')) {
      if (navigatorKey.currentState?.canPop() ?? false) {
        _speak("Going back.");
        navigatorKey.currentState?.pop();
      } else {
        _speak("No previous page to go back to.");
      }
    } else {
      _speak("Sorry, I did not understand the command.");
    }
  }

  void _navigateTo(Widget page) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _navigateToChapter(String name) {
    final id = chapterMap[name.toLowerCase()];
    if (id != null) {
      _navigateTo(ChapterDetailPage(chapterId: id));
    } else {
      _speak("Chapter $name not found.");
    }
  }

  void _navigateToExercise(String name) async {
    final id = chapterMap[name.toLowerCase()];
    if (id != null) {
      try {
        final chapterSnap = await _firebaseService.getChapterDetail(id);
        final data = chapterSnap.data();
        final exercises = data?['exercise'] as Map<String, dynamic>?;

        if (exercises != null) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (_) => ChapterExercisePage(
                exercises: exercises,
                chapterName: data?['name'] ?? 'unknown',
              ),
            ),
          );
        } else {
          _speak("No exercises found for $name.");
        }
      } catch (e) {
        _speak("Failed to load exercise for $name.");
      }
    } else {
      _speak("Exercise for $name not found.");
    }
  }

  Future<void> _speak(String text) async {
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    await _tts.speak(text);
  }
}
