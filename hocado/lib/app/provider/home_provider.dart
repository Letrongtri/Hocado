import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

final homeViewModelProvider = StreamNotifierProvider<HomeViewModel, HomeState>(
  HomeViewModel.new,
);
