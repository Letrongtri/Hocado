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

  Future<void> saveString(String key, String value) async {
    await prefs.setString(key, value);
  }

  Future<String?> loadString(String key) async => prefs.getString(key);

  Future<void> saveBool(String key, bool value) async {
    await prefs.setBool(key, value);
  }

  Future<bool> loadBool(String key) async => prefs.getBool(key) ?? false;
}
