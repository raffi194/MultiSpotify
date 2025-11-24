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
  }) : super(const AsyncValue.loading());

  Future<void> load() async {
    state = const AsyncValue.loading();
    final data = await listFavorites.execute();
    state = AsyncValue.data(data);
  }

  Future<void> add(String songId) async {
    await markFavorite.execute(songId);
    await load();
  }
}
