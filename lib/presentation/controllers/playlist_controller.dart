import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/playlist_entity.dart';
import '../../domain/entities/song_entity.dart';

import '../../application/playlist/list_playlist_user_usecase.dart';
import '../../application/playlist/list_song_in_playlist_usecase.dart';
import '../../application/playlist/create_playlist_usecase.dart';
import '../../application/playlist/add_song_to_playlist_usecase.dart';


// ============================================================================
// PROVIDER: LIST LAGU DALAM PLAYLIST (DETAIL PLAYLIST)
// ============================================================================
final playlistControllerProviderSongs =
    StateNotifierProvider<PlaylistSongsController, AsyncValue<List<SongEntity>>>(
  (ref) => PlaylistSongsController(),
);


// ============================================================================
// CONTROLLER UNTUK SONGS DALAM PLAYLIST
// ============================================================================
class PlaylistSongsController extends StateNotifier<AsyncValue<List<SongEntity>>> {
  PlaylistSongsController() : super(const AsyncValue.loading());

  void setLoading() => state = const AsyncValue.loading();
  void setData(List<SongEntity> songs) => state = AsyncValue.data(songs);
  void setError(Object e, StackTrace s) => state = AsyncValue.error(e, s);
}


// ============================================================================
// CONTROLLER UTAMA PLAYLIST
// ============================================================================
class PlaylistController extends StateNotifier<AsyncValue<List<PlaylistEntity>>> {
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

  // ==========================================================================
  // LOAD SEMUA PLAYLIST USER
  // ==========================================================================
  Future<void> loadPlaylists(String userId) async {
    state = const AsyncValue.loading();
    try {
      final data = await listPlaylistUser.execute(userId);
      state = AsyncValue.data(data);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  // ==========================================================================
  // BUAT PLAYLIST
  // ==========================================================================
  Future<void> create(String name, String description, String userId) async {
    await createPlaylist.execute(name, description);
    await loadPlaylists(userId);
  }

  // ==========================================================================
  // TAMBAHKAN LAGU KE PLAYLIST
  // ==========================================================================
  Future<void> addToPlaylist(String playlistId, String songId, String userId) async {
    await addSongToPlaylist.execute(playlistId, songId);
    await loadPlaylists(userId);
  }

  // ==========================================================================
  // LOAD LAGU DALAM PLAYLIST
  // ==========================================================================
  Future<void> loadSongsInPlaylist(String playlistId) async {
    final songsState = ref.read(playlistControllerProviderSongs.notifier);
    songsState.setLoading();

    try {
      final data = await listSongsInPlaylist.execute(playlistId);
      songsState.setData(data);
    } catch (e, s) {
      songsState.setError(e, s);
    }
  }
}
