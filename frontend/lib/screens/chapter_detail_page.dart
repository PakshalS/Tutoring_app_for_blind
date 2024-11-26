import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/section_widget.dart';
import 'chapter_exercise_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChapterDetailPage extends StatelessWidget {
  final String chapterId;

  const ChapterDetailPage({super.key, required this.chapterId});

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chapter Details"),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: firebaseService.getChapterDetail(chapterId),
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
          final sections = data?['sections'] as Map<String, dynamic>?;
          final exercises = data?['exercise'] as Map<String, dynamic>?;

          // Sort sections by their keys
          final sortedKeys = sections?.keys.toList()
            ?..sort((a, b) {
              final numberA =
                  int.tryParse(a.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
              final numberB =
                  int.tryParse(b.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
              return numberA.compareTo(numberB);
            });

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chapter Title
                  Text(
                    data?['name'] ?? 'Unknown Chapter',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Render Sorted Sections
                  if (sortedKeys != null)
                    ...sortedKeys.map((key) {
                      final section = sections?[key];
                      return SectionWidget(section: section);
                    }),

                  const SizedBox(height: 20),

                  // Go to Exercise Button
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
          );
        },
      ),
    );
  }
}
