import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch all chapters for the subject
  Future<List<QueryDocumentSnapshot>> getChapters() async {
    final snapshot = await _firestore
        .collection('subjects')
        .doc('quantitativeAptitude')
        .collection('chapters')
        .get();
    return snapshot.docs;
  }

  /// Fetch a specific chapter's details
  Future<DocumentSnapshot<Map<String, dynamic>>> getChapterDetail(
      String chapterId) async {
    return await _firestore
        .collection('subjects')
        .doc('quantitativeAptitude')
        .collection('chapters')
        .doc(chapterId)
        .get();
  }
}
