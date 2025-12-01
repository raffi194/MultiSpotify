import '../entities/playlist_entity.dart';
import '../entities/song_entity.dart';

abstract class PlaylistRepository {
  Future<void> createPlaylist(String name, String description);

  // Perbaikan: menerima name + description
  Future<void> updatePlaylist(String id, String name, String description);

  Future<void> deletePlaylist(String id);

  Future<List<PlaylistEntity>> listPlaylists(String userId);
  Future<List<SongEntity>> listSongsInPlaylist(String playlistId);

  Future<void> addSong(String playlistId, String songId);
  Future<void> removeSong(String playlistId, String songId);

  Future<void> duplicatePlaylist(String playlistId);

  Future<String?> fetchFirstSongCover(String playlistId);
}
