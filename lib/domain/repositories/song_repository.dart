import '../entities/song_entity.dart';

abstract class SongRepository {
  Future<List<String>> searchArtists(String keyword);   // NEW
  Future<List<SongEntity>> fetchAll();
  Future<List<SongEntity>> searchSongs(String keyword); // ← ADD
  Future<void> uploadSong(SongEntity song);
  Future<void> deleteSong(String id);
}
