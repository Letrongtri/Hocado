import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';

final userFlashcardProgressServicesProvider =
    Provider<UserFlashcardProgressService>((ref) {
      final firestore = ref.read(firestoreProvider);
      return UserFlashcardProgressService(firestore);
    });

final userFlashcardProgressRepoProvider = Provider<UserFlashcardProgressRepo>((
  ref,
) {
  final service = ref.read(userFlashcardProgressServicesProvider);
  return UserFlashcardProgressRepo(userFlashcardProgressService: service);
});
