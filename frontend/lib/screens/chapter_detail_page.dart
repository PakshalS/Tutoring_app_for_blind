import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/section_widget.dart';
import '../widgets/exercise_widget.dart';
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

          return SingleChildScrollView(
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
                  const SizedBox(height: 20),
                  if (sections != null)
                    ...sections.entries.map((entry) {
                      return SectionWidget(section: entry.value);
                    }),
                  if (exercises != null) ExerciseWidget(exercises: exercises),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
