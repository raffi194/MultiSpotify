import '../../domain/repositories/favorite_repository.dart';

class MarkFavoriteUsecase {
  final FavoriteRepository repo;
  MarkFavoriteUsecase(this.repo);

  Future execute(String songId) {
    return repo.markFavorite(songId);
  }
}
