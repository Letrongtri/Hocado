import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/presentation/viewmodels/search/search_state.dart';
import 'package:hocado/presentation/viewmodels/search/search_view_model.dart';

final searchViewModelProvider =
    AsyncNotifierProvider<SearchViewModel, SearchState>(
      SearchViewModel.new,
    );
