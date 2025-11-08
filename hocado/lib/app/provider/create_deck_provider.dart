import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

// ViewModel for the create deck screen
final createDeckViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<CreateDeckViewModel, CreateDeckState, String?>(
      CreateDeckViewModel.new,
    );
