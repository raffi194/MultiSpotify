import '../../domain/repositories/favorite_repository.dart';

class ListFavoritesUsecase {
  final FavoriteRepository repo;
  ListFavoritesUsecase(this.repo);

  Future execute() {
    return repo.listFavorites();
  }
}
