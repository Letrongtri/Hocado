import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/data/models/learning_settings.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

final testViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<TestViewModel, TestState, (String, LearningSettings)>(
      (args) => TestViewModel(args.$1, args.$2),
    );
