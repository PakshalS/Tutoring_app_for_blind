import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import 'chapter_detail_page.dart';

class ChapterListPage extends StatelessWidget {
  const ChapterListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chapters",
          style:
              TextStyle(fontSize: 24), // Larger app bar title for accessibility
        ),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: firebaseService.getChapters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.redAccent,
                ),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No chapters available",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            );
          }

          final chapters = snapshot.data!;
          return ListView.builder(
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              final chapter = chapters[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Card(
                  color: Colors.teal.shade50, // High-contrast background color
                  elevation: 4.0, // Slight shadow for better visibility
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      chapter['name'],
                      style: const TextStyle(
                        fontSize: 22, // Larger text size for readability
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // High contrast for text
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChapterDetailPage(chapterId: chapter.id),
                        ),
                      );
                    },
                    trailing: const Icon(
                      Icons.arrow_forward,
                      color: Colors.black54,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
