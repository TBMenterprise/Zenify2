import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mainproject/models/chat_message.dart';

class AIService {
  final String _apiKey = 'AIzaSyCfVX9EoVWUlBpvcdtbyh1utNWjMG3ix8U';
  late final GenerativeModel _model;

  AIService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      systemInstruction: Content.text(
        'You are a compassionate and empathetic therapist named Zenify. Your goal is to provide supportive and understanding responses, help users explore their feelings, and offer constructive coping mechanisms. Always maintain a calm and non-judgmental tone. Do not give medical advice or diagnose conditions. Encourage users to seek professional help if their issues are beyond your scope. Keep your replies short and concise but emphatic and bond with the user.you have great memory of what the user says',
      ),
    );
  }

  Future<String> getResponse(List<ChatMessage> messages) async {
    try {
      // Convert ChatMessage list to Content list for the model
      final history = messages.map((msg) => Content(
        (msg.isUser ? 'user' : 'model'),
        [TextPart(msg.text)],
      )).toList();

      final chat = _model.startChat(history: history);

      final response = await chat.sendMessage(Content.text(messages.last.text));
      return response.text ?? '';
    } catch (e) {
      // ignore: avoid_print
      print('Error getting response from Gemini: $e');
      return 'Sorry, something went wrong.';
    }
  }
}