import '../../../domain/entities/song_entity.dart';
import '../../../domain/repositories/song_repository.dart';

class SearchSongsUsecase {
  final SongRepository repository;

  SearchSongsUsecase(this.repository);

  Future<List<SongEntity>> execute(String keyword) {
    return repository.searchSongs(keyword);
  }
}
