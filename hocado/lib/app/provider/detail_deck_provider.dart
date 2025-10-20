import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';
import 'package:hocado/presentation/viewmodels/detail_deck/detail_deck_state.dart';
import 'package:hocado/presentation/viewmodels/detail_deck/detail_deck_async_view_model.dart';

// ViewModel for the detail deck screen
final detailDeckViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<DetailDeckAsyncViewModel, DetailDeckState, String>(
      DetailDeckAsyncViewModel.new,
    );

// Provider to manage the flip state of flashcards
final flipStateProvider = StateProvider.family<bool, int>(
  (ref, cardIndex) => false,
);
