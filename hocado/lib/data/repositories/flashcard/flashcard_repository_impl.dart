import 'dart:convert';

import 'package:hocado/data/models/flashcard.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  final FlashcardService _flashcardService;
  final GeminiService _geminiService;

  FlashcardRepositoryImpl({
    required FlashcardService flashcardService,
    required GeminiService geminiService,
  }) : _flashcardService = flashcardService,
       _geminiService = geminiService;

  @override
  Future<void> createAndUpdateFlashcards(
    List<Flashcard> flashcardData,
    String deckId,
  ) async {
    try {
      await _flashcardService.createAndUpdateFlashcards(
        flashcardData.map((card) => card.toMap()).toList(),
        deckId,
      );
    } catch (e) {
      throw Exception("Could not create flashcards");
    }
  }

  @override
  Future<void> deleteFlashcards(
    List<String> flashcardIds,
    String deckId,
  ) async {
    try {
      return await _flashcardService.deleteFlashcards(flashcardIds, deckId);
    } catch (e) {
      throw Exception("Could not delete flashcards");
    }
  }

  @override
  Future<List<Flashcard>> getFlashcardsByDeckId(String deckId) async {
    try {
      final docs = await _flashcardService.getFlashcardsByDeckId(deckId);

      if (docs.isEmpty) {
        return [];
      }

      return docs.map((doc) => Flashcard.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception("Could not retrieve flashcards");
    }
  }

  @override
  Future<void> deleteFlashcardsByDeckId(String deckId) async {
    try {
      return await _flashcardService.deleteFlashcardsByDeckId(deckId);
    } catch (e) {
      throw Exception("Could not delete flashcards by deck id");
    }
  }

  @override
  Future<List<Flashcard>> generateFlashcardsFromText(String text) async {
    final prompt =
        '''
          You are an AI that generates flashcards from a given text. Your task is to read the provided content and create a set of flashcards that capture its key ideas.
          Follow these rules strictly:
            1. Produce pairs of concise questions (“front”) and succinct answers (“back”) that summarize the main points of the input text.
            2. Keep every question short and direct; keep every answer brief and clear.
            3. Your output must be a pure JSON array only — no markdown formatting, no code fences, no explanations, no introductory sentences.
            4. JSON structure: [{"front": "Question", "back": "Answer"}]
          Here is the input text to process:
          $text
        ''';

    final rawResponse = await _geminiService.generateContent(prompt);

    if (rawResponse == null) {
      throw Exception("Could not generate flashcards from text");
    }

    try {
      final List<dynamic> jsonList = jsonDecode(rawResponse);

      final result = jsonList.map((e) => Flashcard.fromGemini(e)).toList();
      print(result);

      return result;
    } catch (e) {
      throw Exception("Format error: $e");
    }
  }
}
