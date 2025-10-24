import 'package:shared_preferences/shared_preferences.dart';

class LocalSettingsService {
  final SharedPreferences prefs;

  LocalSettingsService(this.prefs);

  String _keyForDeck(String userId, String deckId) =>
      'deck_${userId}_${deckId}_settings';

  Future<String?> loadDeckSettings(
    String userId,
    String deckId,
  ) async {
    final raw = prefs.getString(_keyForDeck(userId, deckId));
    if (raw == null) return null;
    return raw;
  }

  Future<void> saveDeckSettings(
    String userId,
    String deckId,
    String settings,
  ) async {
    await prefs.setString(_keyForDeck(userId, deckId), settings);
  }
}
