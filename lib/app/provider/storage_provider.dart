import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/services/services.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  final storage = ref.read(firebaseStorageProvider);
  return StorageService(storage: storage);
});
