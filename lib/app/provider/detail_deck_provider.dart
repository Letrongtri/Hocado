import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';
// ignore: depend_on_referenced_packages
import 'package:riverpod/legacy.dart';

// ViewModel for the detail deck screen
final detailDeckViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<DetailDeckAsyncViewModel, DetailDeckState, String>(
      DetailDeckAsyncViewModel.new,
    );

// Provider to manage the flip state of flashcards
final flipStateProvider = StateProvider.family<bool, int>(
  (ref, cardIndex) => false,
);
