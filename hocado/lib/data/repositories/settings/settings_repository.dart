import 'package:hocado/data/models/learning_settings.dart';
import 'package:hocado/data/services/local_settings_service.dart';
import 'package:hocado/data/services/remote_settings_service.dart';

class SettingsRepository {
  final LocalSettingsService _localSettingsService;
  final RemoteSettingsService _remoteSettingsService;

  SettingsRepository({
    required LocalSettingsService localSettingsService,
    required RemoteSettingsService remoteSettingsService,
  }) : _localSettingsService = localSettingsService,
       _remoteSettingsService = remoteSettingsService;

  // Lấy cài đặt học (LearningSettings) cho 1 deck
  // Ưu tiên dữ liệu mới nhất giữa local và remote
  Future<LearningSettings> getEffectiveDeckSettings(
    String deckId,
    String uid,
  ) async {
    try {
      final localJson = await _localSettingsService.loadDeckSettings(
        uid,
        deckId,
      );
      final local = localJson != null
          ? LearningSettings.fromSharedPrefs(localJson)
          : null;

      final remoteSnap = await _remoteSettingsService.fetchDeckSettings(
        uid,
        deckId,
      );
      final remote = remoteSnap?.data() != null
          ? LearningSettings.fromFirestore(remoteSnap!)
          : null;

      // Nếu cả 2 đều không có thì tạo mặc định
      if (local == null && remote == null) {
        final defaultSettings = LearningSettings.empty();

        await _remoteSettingsService.upsertDeckSettings(
          uid,
          deckId,
          defaultSettings.toMap(),
        );
        await _localSettingsService.saveDeckSettings(
          uid,
          deckId,
          defaultSettings.toSharedPrefsString(),
        );
        return defaultSettings;
      }

      // Nếu chỉ remote có => lưu vào local
      if (local == null) {
        await _localSettingsService.saveDeckSettings(
          uid,
          deckId,
          remote!.toSharedPrefsString(),
        );
        return remote;
      }

      // Nếu chỉ local có => lưu vào remote
      if (remote == null) {
        await _remoteSettingsService.upsertDeckSettings(
          uid,
          deckId,
          local.toMap(),
        );
        return local;
      }

      // Both exist: pick the one with newer updatedAt
      if (local.updatedAt.isAfter(remote.updatedAt)) {
        await _remoteSettingsService.upsertDeckSettings(
          uid,
          deckId,
          local.toMap(),
        );
        return local;
      } else {
        await _localSettingsService.saveDeckSettings(
          uid,
          deckId,
          remote.toSharedPrefsString(),
        );
        return remote;
      }
    } catch (e) {
      return LearningSettings.empty();
    }
  }

  Future<void> saveDeckSettingsAsDefault(
    String did,
    String uid,
    LearningSettings settings,
  ) async {
    await _localSettingsService.saveDeckSettings(
      uid,
      did,
      settings.toSharedPrefsString(),
    );
    await _remoteSettingsService.upsertDeckSettings(uid, did, settings.toMap());
  }
}
