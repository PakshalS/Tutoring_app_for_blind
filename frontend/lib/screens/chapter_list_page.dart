import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import 'chapter_detail_page.dart';
import '../services/current_location_service.dart';
import '../widgets/voice_wrapper.dart';

class ChapterListPage extends StatelessWidget {
  const ChapterListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();
    CurrentLocationService.setPage('chapter_list');

    return VoiceWrapper(
      child: Scaffold(
        backgroundColor: Colors.black, // High-contrast black background
        appBar: AppBar(
          backgroundColor: Colors.yellow[700], // Bright yellow for contrast
          title: const Text(
            "Chapters",
            style: TextStyle(
              fontSize: 30, // Larger text for accessibility
              fontWeight: FontWeight.bold,
              color: Colors.black, // High contrast with app bar background
            ),
          ),
        ),
        body: FutureBuilder<List<QueryDocumentSnapshot>>(
          future: firebaseService.getChapters(),
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
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No chapters available",
                  style: TextStyle(
                    fontSize: 24, // Large text for accessibility
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow[700], // High contrast
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0), // Larger padding
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: Card(
                      color:
                          Colors.yellow[700], // Bright yellow card for contrast
                      elevation: 8.0, // Increased shadow for premium feel
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16.0), // Rounded edges
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.all(20.0), // Larger touch area
                        title: Text(
                          chapter['name'],
                          style: const TextStyle(
                            fontSize: 26, // Larger text for accessibility
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // High contrast
                            letterSpacing: 1.2, // Premium typography
                          ),
                        ),
                        onTap: () {
                          print('Tapped Chapter ID: ${chapter.id}');
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
                          color: Colors.black,
                          size: 30, // Larger icon for accessibility
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
