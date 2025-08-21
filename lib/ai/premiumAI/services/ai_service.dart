import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const _apiUrl = "https://api-inference.huggingface.co/models/microsoft/DialoGPT-medium";
  static const _apiKey = "YOUR_HUGGINGFACE_TOKEN"; // Insert your token

  static Future<String> getResponse(String prompt) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        "Authorization": "Bearer $_apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"inputs": prompt}),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded[0]["generated_text"] ?? "I couldn’t think of a reply.";
    } else {
      return "Error: ${response.statusCode}";
    }
  }
}