import 'package:audioplayers/audioplayers.dart';

class AudioService {
  AudioService() : _player = AudioPlayer();

  final AudioPlayer _player;

  Future<void> playTransitionSound({bool enabled = true}) async {
    if (!enabled) {
      return;
    }

    try {
      await _player.play(AssetSource('audio/ding.mp3'));
    } catch (_) {
      // Keep timer flow resilient if audio asset is missing.
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
