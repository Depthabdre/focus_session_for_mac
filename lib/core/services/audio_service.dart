import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  AudioService() : _player = AudioPlayer();

  final AudioPlayer _player;
  Timer? _stopTimer;

  Future<void> playTransitionSound({bool enabled = true}) async {
    if (!enabled) {
      return;
    }

    try {
      _stopTimer?.cancel();
      // Set to loop so the alarm continues for 15 seconds
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('audio/idoberg-creepy-halloween-bells-loop-408748.mp3'));
      
      // Auto-stop after 15 seconds if not manually stopped
      _stopTimer = Timer(const Duration(seconds: 15), () {
        stopSound();
      });
    } catch (_) {
      // Keep timer flow resilient if audio asset is missing.
    }
  }

  Future<void> stopSound() async {
    _stopTimer?.cancel();
    try {
      await _player.stop();
    } catch (_) {}
  }

  Future<void> dispose() async {
    _stopTimer?.cancel();
    await _player.dispose();
  }
}
