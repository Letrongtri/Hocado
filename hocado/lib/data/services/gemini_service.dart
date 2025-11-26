import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiService {
  final Gemini _gemini = Gemini.instance;

  Future<String?> generateContent(String prompt) async {
    try {
      final value = await _gemini.prompt(
        parts: [Part.text(prompt)],
        // generationConfig: GenerationConfig(
        //   maxOutputTokens: 8192,
        // ),
      );
      return value?.output;
    } catch (e) {
      throw Exception("Could not generate content: $e");
    }
  }
}
