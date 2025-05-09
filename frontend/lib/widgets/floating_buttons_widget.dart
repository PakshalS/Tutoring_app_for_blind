import 'package:flutter/material.dart';
import '../services/tts_service.dart';

class FloatingButtonsWidget extends StatelessWidget {
  final Function onNext;
  final Function onPrevious;
  final String currentContent;
  final VoidCallback? onStop;

  final TTSService _ttsService = TTSService();

  FloatingButtonsWidget({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.currentContent,
    this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: 'play',
            backgroundColor: Colors.yellow[700], // Bright yellow for contrast
            onPressed: () => _ttsService.speak(currentContent),
            child: const Icon(
              Icons.play_arrow,
              size: 36, // Larger icon for accessibility
              color: Colors.black, // High contrast
            ),
            elevation: 8.0, // Increased shadow for premium feel
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // Rounded edges
            ),
          ),
          const SizedBox(width: 20), // Increased spacing
          FloatingActionButton(
            heroTag: 'pause',
            backgroundColor: Colors.yellow[700], // Bright yellow for contrast
            onPressed: _ttsService.pause,
            child: const Icon(
              Icons.pause,
              size: 36, // Larger icon for accessibility
              color: Colors.black, // High contrast
            ),
            elevation: 8.0, // Increased shadow for premium feel
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // Rounded edges
            ),
          ),
          const SizedBox(width: 20), // Increased spacing
          FloatingActionButton(
            heroTag: 'Previous',
            backgroundColor: Colors.yellow[700], // Bright yellow for contrast
            onPressed: () {
              _ttsService.stop();
              onStop?.call();
              onPrevious();
            },
            child: const Icon(
              Icons.skip_previous,
              size: 36, // Larger icon for accessibility
              color: Colors.black, // High contrast
            ),
            elevation: 8.0, // Increased shadow for premium feel
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // Rounded edges
            ),
          ),
          const SizedBox(width: 20), // Increased spacing
          FloatingActionButton(
            heroTag: 'next',
            backgroundColor: Colors.yellow[700], // Bright yellow for contrast
            onPressed: () {
              _ttsService.stop();
              onStop?.call();
              onNext();
            },
            child: const Icon(
              Icons.skip_next,
              size: 36, // Larger icon for accessibility
              color: Colors.black, // High contrast
            ),
            elevation: 8.0, // Increased shadow for premium feel
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // Rounded edges
            ),
          ),
        ],
      ),
    );
  }
}
