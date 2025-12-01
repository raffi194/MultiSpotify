import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/playlist_entity.dart';
import '../../domain/entities/song_entity.dart';

// Usecases
import '../../application/playlist/list_playlist_user_usecase.dart';
import '../../application/playlist/list_song_in_playlist_usecase.dart';
import '../../application/playlist/create_playlist_usecase.dart';
import '../../application/playlist/add_song_to_playlist_usecase.dart';
import '../../application/playlist/remove_song_from_playlist_usecase.dart';
import '../../application/playlist/update_playlist_usecase.dart'; // <-- penting

// Provider
import '../../core/di/providers.dart';

class PlaylistSongsController
    extends StateNotifier<AsyncValue<List<SongEntity>>> {
  PlaylistSongsController() : super(const AsyncValue.loading());

  void setLoading() => state = const AsyncValue.loading();
  void setData(List<SongEntity> songs) => state = AsyncValue.data(songs);
  void setError(Object e, StackTrace s) => state = AsyncValue.error(e, s);
}

class PlaylistController
    extends StateNotifier<AsyncValue<List<PlaylistEntity>>> {
  final ListPlaylistUserUsecase listPlaylistUser;
  final CreatePlaylistUsecase createPlaylist;
  final AddSongToPlaylistUsecase addSongToPlaylist;
  final ListSongsInPlaylistUsecase listSongsInPlaylist;
  final RemoveSongFromPlaylistUsecase removeSongUsecase;
  final UpdatePlaylistUsecase updatePlaylistUsecase; // <-- penting
  final Ref ref;

  Map<String, String?> playlistCovers = {};

  PlaylistController({
    required this.listPlaylistUser,
    required this.createPlaylist,
    required this.addSongToPlaylist,
    required this.listSongsInPlaylist,
    required this.removeSongUsecase,
    required this.updatePlaylistUsecase, // <-- penting
    required this.ref,
  }) : super(const AsyncValue.loading());

  Future<void> loadPlaylists(String userId) async {
    state = const AsyncValue.loading();
    try {
      final data = await listPlaylistUser.execute(userId);
      state = AsyncValue.data(data);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> create(String name, String description, String userId) async {
    await createPlaylist.execute(name, description);
    await loadPlaylists(userId);
  }

  Future<void> updatePlaylist(
    String playlistId,
    String newName,
    String newDescription,
    String userId,
  ) async {
    try {
      await updatePlaylistUsecase.execute(
        playlistId,
        newName,
        newDescription,
      );

      await loadPlaylists(userId);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> addToPlaylist(
      String playlistId, String songId, String userId) async {
    await addSongToPlaylist.execute(playlistId, songId);
    await loadSongsInPlaylist(playlistId);
    await loadPlaylists(userId);
  }

  Future<void> removeSong(
      String playlistId, String songId, String userId) async {
    await removeSongUsecase.execute(playlistId, songId);
    await loadSongsInPlaylist(playlistId);
    await loadPlaylists(userId);
  }

  Future<void> delete(String playlistId, String userId) async {
    try {
      final repo = ref.read(playlistRepositoryProvider);
      await repo.deletePlaylist(playlistId);
      await loadPlaylists(userId);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

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

  Future<void> loadPlaylistCovers(String userId) async {
    try {
      final repo = ref.read(playlistRepositoryProvider);
      final playlistsList = await listPlaylistUser.execute(userId);

      final Map<String, String?> covers = {};

      for (final p in playlistsList) {
        final cover = await repo.fetchFirstSongCover(p.id);
        covers[p.id] = cover;
      }

      playlistCovers = covers;
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> loadPlaylistsWithoutSongs(String userId) async {
    try {
      final data = await listPlaylistUser.execute(userId);
      state = AsyncValue.data(data);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> duplicate(String playlistId, String userId) async {
    final repo = ref.read(playlistRepositoryProvider);
    try {
      await repo.duplicatePlaylist(playlistId);
      await loadPlaylists(userId);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
