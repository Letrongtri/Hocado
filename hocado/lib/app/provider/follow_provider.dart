import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';

final followServiceProvider = Provider<FollowService>((ref) {
  final firestore = ref.read(firestoreProvider);
  return FollowService(firestore: firestore);
});

final followRepositoryProvider = Provider<FollowRepository>((ref) {
  final service = ref.read(followServiceProvider);
  return FollowRepositoryImpl(followService: service);
});

final followingUsersProvider = StreamProvider.autoDispose
    .family<List<Follow>, String>((ref, uid) {
      final repository = ref.watch(followRepositoryProvider);
      return repository.getUserFollowingStream(uid);
    });
