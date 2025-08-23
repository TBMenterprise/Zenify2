import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  final String _apiKey = 'AIzaSyCfVX9EoVWUlBpvcdtbyh1utNWjMG3ix8U';
  late final GenerativeModel _model;

  AIService() {
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
  }

  Future<String> getResponse(String text) async {
    try {
      final content = [Content.text(text)];
      final response = await _model.generateContent(content);
      return response.text ?? '';
    } catch (e) {
      // ignore: avoid_print
      print('Error getting response from Gemini: $e');
      return 'Sorry, something went wrong.';
    }
  }
}