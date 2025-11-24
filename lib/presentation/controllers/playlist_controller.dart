import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/playlist_entity.dart';
import '../../domain/entities/song_entity.dart';

// Provider DI (playlistControllerProviderSongs)
import '../../core/di/providers.dart';

// USECASES
import '../../application/playlist/list_playlist_user_usecase.dart';
import '../../application/playlist/list_song_in_playlist_usecase.dart';
import '../../application/playlist/create_playlist_usecase.dart';
import '../../application/playlist/add_song_to_playlist_usecase.dart';


// =======================================================
// CONTROLLER: SONGS IN PLAYLIST (Detail Playlist)
// =======================================================
class PlaylistSongsController
    extends StateNotifier<AsyncValue<List<SongEntity>>> {
  PlaylistSongsController() : super(const AsyncValue.loading());

  void setLoading() => state = const AsyncValue.loading();
  void setData(List<SongEntity> songs) => state = AsyncValue.data(songs);
  void setError(Object e, StackTrace s) => state = AsyncValue.error(e, s);
}


// =======================================================
// CONTROLLER UTAMA PLAYLIST
// =======================================================
class PlaylistController
    extends StateNotifier<AsyncValue<List<PlaylistEntity>>> {
  final ListPlaylistUserUsecase listPlaylistUser;
  final CreatePlaylistUsecase createPlaylist;
  final AddSongToPlaylistUsecase addSongToPlaylist;
  final ListSongsInPlaylistUsecase listSongsInPlaylist;

  final Ref ref;

  PlaylistController({
    required this.listPlaylistUser,
    required this.createPlaylist,
    required this.addSongToPlaylist,
    required this.listSongsInPlaylist,
    required this.ref,
  }) : super(const AsyncValue.loading());

  // ===================================================
  // LOAD PLAYLIST USER
  // ===================================================
  Future<void> loadPlaylists(String userId) async {
    state = const AsyncValue.loading();
    try {
      final data = await listPlaylistUser.execute(userId);
      state = AsyncValue.data(data);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  // ===================================================
  // CREATE PLAYLIST
  // ===================================================
  Future<void> create(
      String name, String description, String userId) async {
    await createPlaylist.execute(name, description);
    await loadPlaylists(userId);
  }

  // ===================================================
  // ADD SONG TO PLAYLIST
  // ===================================================
  Future<void> addToPlaylist(
      String playlistId, String songId, String userId) async {
    await addSongToPlaylist.execute(playlistId, songId);
    await loadPlaylists(userId);
  }

  // ===================================================
  // LOAD SONGS IN PLAYLIST (DETAIL PLAYLIST)
  // ===================================================
  Future<void> loadSongsInPlaylist(String playlistId) async {
    final songState = ref.read(playlistControllerProviderSongs.notifier);
    songState.setLoading();

    try {
      final data = await listSongsInPlaylist.execute(playlistId);
      songState.setData(data);
    } catch (e, s) {
      songState.setError(e, s);
    }
  }
}
