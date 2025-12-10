import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/data/services/services.dart';

final musicServiceProvider = Provider((ref) => MusicService());
