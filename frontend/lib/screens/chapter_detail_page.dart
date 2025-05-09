import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../services/text_processor_service.dart';
import '../widgets/section_widget.dart';
import '../widgets/floating_buttons_widget.dart';
import 'chapter_exercise_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/tts_service.dart';
import '../services/current_location_service.dart';
import '../widgets/voice_wrapper.dart';

class ChapterDetailPage extends StatefulWidget {
  final String chapterId;

  const ChapterDetailPage({super.key, required this.chapterId});

  @override
  _ChapterDetailPageState createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends State<ChapterDetailPage> {
  int currentSectionIndex = 0;
  List<String> sortedKeys = [];
  final TTSService _ttsService = TTSService();
  Map<String, dynamic>? sections;
  final TextProcessorService _textProcessor = TextProcessorService();

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();

    return VoiceWrapper(
      child: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          if (didPop) {
            _ttsService.stop(); // Stops the voice when back button is pressed
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black, // High-contrast black background
          appBar: AppBar(
            backgroundColor: Colors.yellow[700], // Bright yellow for contrast
            title: const Text(
              "Chapter Details",
              style: TextStyle(
                fontSize: 30, // Larger text for accessibility
                fontWeight: FontWeight.bold,
                color: Colors.black, // High contrast with app bar background
                letterSpacing: 1.2, // Premium typography
              ),
            ),
          ),
          body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: firebaseService.getChapterDetail(widget.chapterId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.yellow, // Yellow for visibility
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: TextStyle(
                      fontSize: 24, // Large text for accessibility
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow[700], // High contrast
                    ),
                  ),
                );
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(
                  child: Text(
                    "Chapter not found",
                    style: TextStyle(
                      fontSize: 24, // Large text for accessibility
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow[700], // High contrast
                    ),
                  ),
                );
              }

              final data = snapshot.data!.data();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                CurrentLocationService.setPage('chapter_detail',
                    chapter: data?['name']);
              });

              final exercises = data?['exercise'] as Map<String, dynamic>?;
              sections = data?['sections'] as Map<String, dynamic>?;

              sortedKeys = sections?.keys.toList() ?? [];
              sortedKeys.sort((a, b) {
                final numberA =
                    int.tryParse(a.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
                final numberB =
                    int.tryParse(b.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
                return numberA.compareTo(numberB);
              });

              final currentSection = (sortedKeys.isNotEmpty && sections != null)
                  ? sections![sortedKeys[currentSectionIndex]]
                  : null;

              final String aggregatedContent = currentSection != null
                  ? _textProcessor.collectContent(currentSection)
                  : '';

              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0), // Increased padding
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // Center content
                        children: [
                          Text(
                            data?['name'] ?? 'Unknown Chapter',
                            textAlign: TextAlign.center, // Center title
                            style: TextStyle(
                              fontSize: 28, // Larger text for accessibility
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow[700], // High contrast
                              letterSpacing: 1.2, // Premium typography
                            ),
                          ),
                          const SizedBox(height: 20),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            child: FloatingButtonsWidget(
                              currentContent: aggregatedContent,
                              onNext: _goToNextSection,
                              onPrevious: _goToPreviousSection,
                              onStop: () => _ttsService.stop(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (currentSection != null)
                            SectionWidget(section: currentSection)
                          else
                            Text(
                              "No sections available.",
                              style: TextStyle(
                                fontSize: 24, // Large text for accessibility
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow[700], // High contrast
                              ),
                            ),
                          const SizedBox(height: 30),
                          if (sortedKeys.isNotEmpty) const SizedBox(height: 30),
                          if (exercises != null)
                            Semantics(
                              label: 'Go to Exercises Button',
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.yellow[700], // High contrast
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                        horizontal: 40), // Larger touch area
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          16), // Rounded edges
                                    ),
                                    elevation: 8, // Shadow for premium feel
                                    shadowColor: Colors.yellow[300]!
                                        .withOpacity(0.5), // Glow effect
                                  ),
                                  onPressed: () {
                                    _ttsService
                                        .stop(); // Stop TTS before navigating
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChapterExercisePage(
                                          exercises: exercises,
                                          chapterName:
                                              data?['name'] ?? 'unknown',
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Go to Exercises",
                                    style: TextStyle(
                                      fontSize:
                                          24, // Large text for accessibility
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // High contrast
                                      letterSpacing: 1.2, // Premium typography
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _goToNextSection() {
    setState(() {
      if (currentSectionIndex < sortedKeys.length - 1) {
        currentSectionIndex++;
      }
    });
  }

  void _goToPreviousSection() {
    setState(() {
      if (currentSectionIndex > 0) {
        currentSectionIndex--;
      }
    });
  }
}
