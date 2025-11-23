import '../entities/song_entity.dart';

abstract class SongRepository {
  Future<List<SongEntity>> fetchAll();
  Future<void> uploadSong(SongEntity song);
  Future<void> deleteSong(String id);
}
