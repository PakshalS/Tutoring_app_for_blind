import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  static Future<String> fetchChatbotResponse(String question) async {
    try {
      final response = await http.post(
        Uri.parse('$backendUrl/'), // ✅ Corrected API endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': question}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['response'];
      } else {
        return "Error: Unable to fetch response. (${response.statusCode})";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
