import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../application/favorites/list_favorites_usecase.dart';
import '../../application/favorites/mark_favorite_usecase.dart';

class FavoriteController extends StateNotifier<AsyncValue<List<FavoriteEntity>>> {
  final ListFavoritesUsecase listFavorites;
  final MarkFavoriteUsecase markFavorite;

  FavoriteController({
    required this.listFavorites,
    required this.markFavorite,
  }) : super(const AsyncValue.loading()) {
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    try {
      final favorites = await listFavorites.execute();
      state = AsyncValue.data(favorites);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> toggleFavorite(String songId) async {
    try {
      await markFavorite.execute(songId);

      // after marking favorite, refresh list
      final favorites = await listFavorites.execute();
      state = AsyncValue.data(favorites);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
