import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../domain/entities/song_entity.dart';

/// STATE MODEL
class PlayerStateModel {
  final SongEntity? currentSong;
  final bool isPlaying;

  PlayerStateModel({
    required this.currentSong,
    required this.isPlaying,
  });

  PlayerStateModel copyWith({
    SongEntity? currentSong,
    bool? isPlaying,
  }) {
    return PlayerStateModel(
      currentSong: currentSong ?? this.currentSong,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

/// PROVIDER
final playerControllerProvider =
    StateNotifierProvider<PlayerController, PlayerStateModel>((ref) {
  return PlayerController();
});

/// CONTROLLER
class PlayerController extends StateNotifier<PlayerStateModel> {
  final AudioPlayer _audio = AudioPlayer();

  PlayerController()
      : super(PlayerStateModel(currentSong: null, isPlaying: false)) {
    _audio.playerStateStream.listen((event) {
      final playing = event.playing;
      state = state.copyWith(isPlaying: playing);
    });
  }

  // ===============================================================
  // LOAD SONG + PLAY
  // ===============================================================
  Future<void> playSong(SongEntity song) async {
    try {
      state = state.copyWith(currentSong: song);

      await _audio.setUrl(song.audioUrl);
      await _audio.play();

      state = state.copyWith(isPlaying: true);
    } catch (e) {
      print("Error playing song: $e");
    }
  }

  // ===============================================================
  // PAUSE / RESUME
  // ===============================================================
  Future<void> togglePlay() async {
    if (_audio.playing) {
      await _audio.pause();
      state = state.copyWith(isPlaying: false);
    } else {
      await _audio.play();
      state = state.copyWith(isPlaying: true);
    }
  }

  // ===============================================================
  // STOP
  // ===============================================================
  Future<void> stop() async {
    await _audio.stop();
    state = state.copyWith(isPlaying: false);
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }
}
