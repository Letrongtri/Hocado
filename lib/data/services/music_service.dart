import 'package:audioplayers/audioplayers.dart';

class MusicService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  MusicService() {
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _audioPlayer.setVolume(0.3);
  }

  Future<void> playMusic() async {
    if (_audioPlayer.state == PlayerState.playing) return;
    await _audioPlayer.play(AssetSource('sounds/bg_music.mp3'));
  }

  Future<void> stopMusic() async => await _audioPlayer.stop();

  Future<void> pauseMusic() async => await _audioPlayer.pause();

  Future<void> resumeMusic() async => await _audioPlayer.resume();
}
