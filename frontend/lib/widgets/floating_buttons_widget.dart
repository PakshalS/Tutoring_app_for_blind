import 'package:flutter/material.dart';
import '../services/tts_service.dart';

class FloatingButtonsWidget extends StatelessWidget {
  final Function onNext;
  final Function onPrevious;
  final String currentContent;

  final TTSService _ttsService = TTSService();

  FloatingButtonsWidget({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.currentContent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Semantics(
          label: "Play",
          child: FloatingActionButton(
            heroTag: 'play',
            onPressed: () => _ttsService.speak(currentContent),
            child: const Icon(Icons.play_arrow),
          ),
        ),
        const SizedBox(width: 16),
        Semantics(
          label: 'Pause',
          child: FloatingActionButton(
            heroTag: 'pause',
            onPressed: _ttsService.pause,
            child: const Icon(Icons.pause),
          ),
        ),
        const SizedBox(width: 16),
        Semantics(
          label: 'Previous',
          child: FloatingActionButton(
            heroTag: 'Previous',
            onPressed: () => onPrevious(),
            child: const Icon(Icons.skip_previous),
          ),
        ),
        const SizedBox(width: 16),
        Semantics(
          label: 'Next',
          child: FloatingActionButton(
            heroTag: 'next',
            onPressed: () => onNext(),
            child: const Icon(Icons.skip_next),
          ),
        ),
      ],
    );
  }
}
