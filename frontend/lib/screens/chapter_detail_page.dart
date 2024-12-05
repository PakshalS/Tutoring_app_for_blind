import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../services/text_processor_service.dart';
import '../widgets/section_widget.dart';
import '../widgets/floating_buttons_widget.dart';
import 'chapter_exercise_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChapterDetailPage extends StatefulWidget {
  final String chapterId;

  const ChapterDetailPage({super.key, required this.chapterId});

  @override
  _ChapterDetailPageState createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends State<ChapterDetailPage> {
  int currentSectionIndex = 0;
  List<String> sortedKeys = [];
  Map<String, dynamic>? sections;
  final TextProcessorService _textProcessor = TextProcessorService();

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chapter Details"),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: firebaseService.getChapterDetail(widget.chapterId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Chapter not found"));
          }

          final data = snapshot.data!.data();
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data?['name'] ?? 'Unknown Chapter',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      if (sortedKeys.isNotEmpty)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: FloatingButtonsWidget(
                              currentContent: aggregatedContent,
                              onNext: _goToNextSection,
                              onPrevious: _goToPreviousSection,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      if (currentSection != null)
                        SectionWidget(section: currentSection)
                      else
                        const Text("No sections available."),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      if (exercises != null)
                        Semantics(
                          label: 'Go to Exercises Button',
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChapterExercisePage(exercises: exercises),
                                ),
                              );
                            },
                            child: const Text("Go to Exercises"),
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
