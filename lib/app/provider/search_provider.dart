import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

final searchViewModelProvider =
    AsyncNotifierProvider<SearchViewModel, SearchState>(
      SearchViewModel.new,
    );
