import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/music_provider.dart';
import 'package:hocado/app/provider/provider.dart';

class MusicManager extends ConsumerStatefulWidget {
  final Widget child;
  const MusicManager({super.key, required this.child});

  @override
  ConsumerState<MusicManager> createState() => _MusicManagerState();
}

class _MusicManagerState extends ConsumerState<MusicManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Đăng ký lắng nghe Lifecycle
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 1. Xử lý khi User ẩn/hiện App
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final musicService = ref.read(musicServiceProvider);
    final isSoundOn =
        ref.read(systemSettingsViewModelProvider).value?.isSoundOn ?? true;

    if (!isSoundOn) return; // Nếu setting tắt tiếng thì không làm gì cả

    switch (state) {
      case AppLifecycleState.paused: // User ẩn app
      case AppLifecycleState.inactive:
        musicService.pauseMusic();
        break;
      case AppLifecycleState.resumed: // User quay lại app
        musicService.resumeMusic();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 2. Lắng nghe thay đổi từ Settings (User bật/tắt tiếng trong app)
    ref.listen(systemSettingsViewModelProvider, (previous, next) {
      next.whenData((state) {
        final musicService = ref.read(musicServiceProvider);
        if (state.isSoundOn) {
          musicService.playMusic();
        } else {
          musicService.stopMusic();
        }
      });
    });

    return widget.child;
  }
}
