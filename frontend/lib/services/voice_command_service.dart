import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:frontend/screens/home_page.dart';
import 'package:frontend/screens/chat_screen.dart';
import 'package:frontend/screens/chapter_list_page.dart';
import 'package:frontend/screens/chapter_detail_page.dart';
import 'package:frontend/screens/chapter_exercise_page.dart';
import 'package:frontend/screens/quiz_page.dart';
import 'package:frontend/screens/guide_screen.dart';
import 'package:frontend/services/firebase_service.dart';
import 'package:frontend/services/current_location_service.dart';
import 'package:frontend/main.dart';
import 'package:string_similarity/string_similarity.dart';

class VoiceCommandService {
  final Map<String, String> chapterMap;
  final FirebaseService _firebaseService = FirebaseService();
  final FlutterTts _tts = FlutterTts();

  VoiceCommandService(this.chapterMap);

  void handleCommand(String command) {
    final cmd = command.toLowerCase().trim();

    if (cmd.contains('where')) {
      _speak(CurrentLocationService.getLocationMessage());
    } else if (cmd.contains('open guide')) {
      _speak("Opening voice command guide.");
      _navigateTo(const GuideScreen());
    } else if (cmd.contains('open home')) {
      _speak("Navigating to Home.");
      _navigateTo(const HomePage());
    } else if (cmd.contains('open bot') || cmd.contains('open chat')) {
      _speak("Opening chatbot.");
      _navigateTo(const ChatScreen());
    } else if (cmd.contains('open quiz')) {
      _speak("Opening quiz.");
      _navigateTo(const QuizPage());
    } else if (cmd.contains('open chapter list')) {
      _speak("Opening chapter list.");
      _navigateTo(const ChapterListPage());
    } else if (cmd.contains('open exercise of')) {
      final name = cmd.split('exercise of').last.trim();
      final matched = _fuzzyMatchChapter(name);
      if (matched != null) {
        _speak("Opening exercise of $matched");
        _navigateToExercise(matched);
      } else {
        _speak("Couldn't match chapter for $name");
      }
    } else if (cmd.startsWith('open ')) {
      final name = cmd.replaceFirst('open ', '').trim();
      final matched = _fuzzyMatchChapter(name);
      if (matched != null) {
        _speak("Opening chapter $matched");
        _navigateToChapter(matched);
      } else {
        _speak("Couldn't match chapter for $name");
      }
    } else if (cmd.contains('go back')) {
      _speak("Going back to home.");
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } else {
      _speak("Sorry, I did not understand the command.");
    }
  }

  /// Returns matched chapter name (from keys of chapterMap) or null
  String? _fuzzyMatchChapter(String input) {
    final keys = chapterMap.keys.toList();
    final matches = input.bestMatch(keys);

    final rating = matches.bestMatch.rating;
    if (rating != null && rating >= 0.5) {
      return matches.bestMatch.target;
    }

    return null;
  }

  void _navigateTo(Widget page) {
    navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => page));
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
      } catch (_) {
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
