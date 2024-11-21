import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_data_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tutoring App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Call the bulk upload function
                await bulkUploadRemainingChapters();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text("Remaining chapters uploaded successfully!")),
                );
              },
              child: const Text("Upload Remaining Chapters"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to a screen to view chapters
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChapterListPage()),
                );
              },
              child: const Text("View Chapters"),
            ),
          ],
        ),
      ),
    );
  }
}

class ChapterListPage extends StatelessWidget {
  const ChapterListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chapters"),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('subjects')
            .doc('quantitativeAptitude')
            .collection('chapters')
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No chapters available"));
          }

          var chapters = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              var chapter = chapters[index];
              return ListTile(
                title: Text(chapter['name']),
                onTap: () {
                  // Optionally, navigate to chapter details page
                },
              );
            },
          );
        },
      ),
    );
  }
}
