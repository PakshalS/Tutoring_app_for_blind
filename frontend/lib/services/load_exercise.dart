import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadExercisesToFirestore() async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Load JSON from assets
  final String jsonString =
      await rootBundle.loadString('lib/assets/exercise.json');
  final Map<String, dynamic> jsonData = jsonDecode(jsonString);

  // Reference to the exercises collection
  final CollectionReference exercisesRef = _firestore
      .collection('subjects')
      .doc('quantitativeAptitude')
      .collection('exercises');

  // Push as a new document
  await exercisesRef.doc('exercise1').set(jsonData);

  print("✅ Exercises uploaded successfully");
}
