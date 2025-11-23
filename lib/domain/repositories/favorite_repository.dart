import '../entities/favorite_entity.dart';

abstract class FavoriteRepository {
  Future<void> markFavorite(String songId);
  Future<List<FavoriteEntity>> listFavorites();
}
