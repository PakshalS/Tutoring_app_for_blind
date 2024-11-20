import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore
import 'json_loader_service.dart'; // Import the updated json_loader_service.dart

/// Function to upload a single chapter to Firestore
Future<void> addChapterToFirestore(
    String chapterFileName, String chapterId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Load chapter data from the JSON file using the loadChapterData function
  Map<String, dynamic> chapterData = await loadChapterData(chapterFileName);

  // Add the chapter document with its sections and exercises
  await firestore
      .collection('subjects')
      .doc('quantitativeAptitude')
      .collection('chapters')
      .doc(chapterId)
      .set({
    "name": chapterData["name"], // Chapter name
    "sections": chapterData["sections"], // Chapter sections as nested data
    "exercise": chapterData["exercise"], // Chapter exercises as nested data
  });
}

/// Bulk upload function to add the remaining chapters
Future<void> bulkUploadRemainingChapters() async {
  // List of the remaining chapters with their file names and IDs
  final remainingChapters = [
    {"file": "simplification.json", "id": "Simplification"},
    {"file": "time_and_work.json", "id": "TimeAndWork"},
  ];

  // Loop through each chapter and upload to Firestore
  for (var chapter in remainingChapters) {
    print("Uploading: ${chapter["id"]}");
    await addChapterToFirestore(chapter["file"]!, chapter["id"]!);
    print("Uploaded: ${chapter["id"]}");
  }
}
