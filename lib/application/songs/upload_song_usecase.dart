import '../../domain/repositories/song_repository.dart';
import '../../domain/entities/song_entity.dart';

class UploadSongUsecase {
  final SongRepository repo;
  UploadSongUsecase(this.repo);

  Future execute(SongEntity song) {
    return repo.uploadSong(song);
  }
}
