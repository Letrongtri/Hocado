import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/presentation/viewmodels/create_deck/create_deck_state.dart';
import 'package:hocado/presentation/viewmodels/create_deck/create_deck_view_model.dart';

// ViewModel for the create deck screen
final createDeckViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<CreateDeckViewModel, CreateDeckState, String?>(
      CreateDeckViewModel.new,
    );
