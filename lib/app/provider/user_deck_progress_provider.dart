import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';

final userDeckProgressServiceProvider = Provider<UserDeckProgressService>((
  ref,
) {
  final firestore = ref.read(firestoreProvider);
  return UserDeckProgressService(firestore: firestore);
});

final userDeckProgressRepositoryProvider = Provider<UserDeckProgressRepository>(
  (ref) {
    final service = ref.read(userDeckProgressServiceProvider);
    return UserDeckProgressRepositoryImpl(userDeckProgressService: service);
  },
);
