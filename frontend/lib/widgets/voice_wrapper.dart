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
  DateTime? _pressStartTime;
  bool _isListening = false;
  bool _isSpeechInitialized = false;
  DateTime? _lastTapTime;
  static const _minTapInterval =
      Duration(milliseconds: 500); // Prevent rapid taps

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    try {
      final available = await _speech.initialize(
        onStatus: (status) {
          debugPrint("Speech status: $status");
          if (status == 'notAvailable' || status == 'error') {
            setState(() => _isSpeechInitialized = false);
            _showSnackBar("Speech recognition is not available.");
          }
        },
      );
      setState(() => _isSpeechInitialized = available);
      if (!available) {
        _showSnackBar("Speech recognition not available on this device.");
      }
    } catch (e) {
      debugPrint("Speech initialization exception: $e");
      setState(() => _isSpeechInitialized = false);
      _showSnackBar("Failed to initialize speech recognition.");
    }
  }

  void _onLongPressStart(_) {
    if (_isListening || !_isSpeechInitialized) return;
    _pressStartTime = DateTime.now();
  }

  void _onLongPressEnd(_) {
    if (_pressStartTime == null || _isListening || !_isSpeechInitialized)
      return;
    final duration = DateTime.now().difference(_pressStartTime!);
    if (duration.inSeconds >= 2) {
      debugPrint("Long press detected for ${duration.inSeconds}s ✅");
      _startListening(source: 'gesture');
    } else {
      debugPrint("Hold not long enough: ${duration.inSeconds}s ❌");
    }
    _pressStartTime = null;
  }

  void _onFabTap() {
    final now = DateTime.now();
    // Prevent rapid taps
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!) < _minTapInterval) {
      debugPrint("Tap ignored: too soon after previous tap");
      return;
    }
    _lastTapTime = now;

    if (!_isSpeechInitialized) {
      _showSnackBar(
          "Speech recognition not available. Please try again later.");
      _initializeSpeech(); // Attempt to reinitialize
      return;
    }

    if (_isListening) {
      debugPrint("FAB tapped while listening, stopping...");
      _stopListening();
    } else {
      debugPrint("FAB tapped, starting listening...");
      _startListening(source: 'fab');
    }
  }

  Future<void> _startListening({required String source}) async {
    if (_isListening || !_isSpeechInitialized) {
      debugPrint(
          "Cannot start listening: already listening or not initialized");
      return;
    }

    try {
      await TTSService().stop(); // Stop any ongoing TTS
      setState(() {
        _isListening = true;
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
        onSoundLevelChange: (level) {
          debugPrint("Sound level: $level");
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 4),
        localeId: 'en_US',
      );

      // Monitor status changes for errors
      _speech.statusListener = (status) {
        debugPrint("Speech status: $status");
        if (status == 'error' || status == 'notRecognized') {
          _showSnackBar("Speech recognition failed. Please try again.");
          _stopListening();
        }
      };

      // Timeout if no input is received
      Future.delayed(const Duration(seconds: 10), () {
        if (_isListening && _lastWords.isEmpty) {
          _showSnackBar("Sorry, no input received.");
          _stopListening();
        }
      });

      debugPrint("Started listening via $source");
    } catch (e) {
      debugPrint("Error starting speech recognition: $e");
      _showSnackBar("Failed to start speech recognition.");
      setState(() => _isListening = false);
    }
  }

  void _stopListening() {
    if (!_isListening) return;
    try {
      _speech.stop();
      setState(() => _isListening = false);
      debugPrint("Stopped listening");
    } catch (e) {
      debugPrint("Error stopping speech recognition: $e");
      _showSnackBar("Failed to stop speech recognition.");
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _stopListening();
    _speech.cancel(); // Clean up speech resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onLongPressStart: _onLongPressStart,
        onLongPressEnd: _onLongPressEnd,
        behavior: HitTestBehavior.translucent,
        child: widget.child,
      ),
      floatingActionButton: Semantics(
        label: 'MIC',
        child: FloatingActionButton(
          onPressed: _onFabTap,
          tooltip: _isListening ? 'Stop Listening' : 'Start Listening',
          backgroundColor: _isListening ? Colors.red : Colors.yellow,
          child: Icon(_isListening ? Icons.mic_off : Icons.mic),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
