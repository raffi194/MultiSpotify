import '../../domain/repositories/song_repository.dart';

class FetchAllSongsUsecase {
  final SongRepository repo;
  FetchAllSongsUsecase(this.repo);

  Future execute() {
    return repo.fetchAll();
  }
}
