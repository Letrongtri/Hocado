import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/data/models/learning_settings.dart';
import 'package:hocado/presentation/viewmodels/learn/learn_state.dart';
import 'package:hocado/presentation/viewmodels/learn/learn_view_model.dart';

final learnViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<LearnViewModel, LearnState, (String, LearningSettings)>(
      (args) => LearnViewModel(args.$1, args.$2),
    );
