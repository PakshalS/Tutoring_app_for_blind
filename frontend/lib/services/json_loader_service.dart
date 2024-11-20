import 'dart:convert'; // For JSON decoding
import 'package:flutter/services.dart' show rootBundle; // For loading assets

/// Function to load a JSON file and return its contents as a Dart map.
/// It accepts the filename dynamically so it can work for all chapters.
Future<Map<String, dynamic>> loadChapterData(String fileName) async {
  try {
    // Load the JSON file as a string
    String jsonString = await rootBundle.loadString('lib/assets/$fileName');

    // Decode the JSON string into a Map and return
    return json.decode(jsonString) as Map<String, dynamic>;
  } catch (e) {
    // Handle any potential errors (e.g., file not found)
    print("Error loading file: $fileName - $e");
    rethrow; // Optional: Rethrow the error if you want to propagate it
  }
}
