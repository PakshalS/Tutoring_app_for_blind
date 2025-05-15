import 'package:flutter/material.dart';
import '../services/current_location_service.dart';
import '../widgets/voice_wrapper.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  final List<String> commands = const [
    '• Open Home',
    '• Open Chat / Open Bot',
    '• Open Chapter List',
    '• Open Quiz',
    '• Open [Chapter Name]',
    '• Open Exercise of [Chapter Name]',
    '• Go Back',
    '• Where are we?',
    '• Open Guide',
  ];

  @override
  Widget build(BuildContext context) {
    CurrentLocationService.setPage('guide');

    return VoiceWrapper(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.yellow[700],
          title: const Text(
            'Command Guide',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.2,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Use following voice commands for navigation:",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 24),
                ...commands.map((command) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        command,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.yellow,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
