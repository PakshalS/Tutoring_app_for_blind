import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../services/voice_command_service.dart';
import '../utils/chapter_map.dart';
import '../services/tts_service.dart';

class VoiceWrapper extends StatefulWidget {
  final Widget child;

  const VoiceWrapper({super.key, required this.child});

  @override
  State<VoiceWrapper> createState() => _VoiceWrapperState();
}

class _VoiceWrapperState extends State<VoiceWrapper> {
  late stt.SpeechToText _speech;
  String _lastWords = '';
  int _tapCount = 0;
  DateTime? _lastTapTime;
  static const _tripleTapDuration =
      Duration(milliseconds: 500); // Time window for triple tap

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _handleTap() {
    final now = DateTime.now();
    if (_lastTapTime == null ||
        now.difference(_lastTapTime!) > _tripleTapDuration) {
      _tapCount = 1;
    } else {
      _tapCount++;
    }
    _lastTapTime = now;

    if (_tapCount == 4) {
      _startListening();
      _tapCount = 0; // Reset tap count
    }
  }

  Future<void> _startListening() async {
    final available = await _speech.initialize();
    if (!available) {
      debugPrint("Speech not available");
      _ttsService.speak("Speech recognition not available");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Speech recognition not available",
            style: TextStyle(
              fontSize: 20, // Larger text for accessibility
              color: Colors.black, // High contrast
            ),
          ),
          backgroundColor: Colors.yellow[700], // Bright yellow for contrast
        ),
      );
      return;
    }

    await TTSService().stop(); // Stop any ongoing TTS
    _ttsService.speak("Voice input started");

    setState(() {
      _lastWords = '';
    });

    _speech.listen(
      onResult: (val) {
        setState(() => _lastWords = val.recognizedWords);

        if (val.finalResult && _lastWords.trim().isNotEmpty) {
          final service = VoiceCommandService(chapterMap);
          service.handleCommand(_lastWords);
          _stopListening();
        }
      },
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 4),
      localeId: 'en_US',
    );

    Future.delayed(const Duration(seconds: 10), () {
      if (_lastWords.isEmpty && _speech.isListening) {
        _ttsService.speak("No input received");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Sorry, no input received",
              style: TextStyle(
                fontSize: 20, // Larger text for accessibility
                color: Colors.black, // High contrast
              ),
            ),
            backgroundColor: Colors.yellow[700], // Bright yellow for contrast
          ),
        );
        _stopListening();
      }
    });
  }

  void _stopListening() {
    _speech.stop();
  }

  TTSService get _ttsService => TTSService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.translucent, // Catch all taps
        child: widget.child,
      ),
      floatingActionButton: Semantics(
        label: 'Start voice input',
        hint: 'Tap to begin voice command input',
        child: FloatingActionButton(
          onPressed: _startListening,
          backgroundColor: Colors.yellow[700], // Bright yellow for contrast
          elevation: 8, // Shadow for premium feel
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded edges
          ),
          child: Icon(
            Icons.mic,
            size: 36, // Larger icon for accessibility
            color: Colors.black, // High contrast
          ),
        ),
      ),
    );
  }
}
