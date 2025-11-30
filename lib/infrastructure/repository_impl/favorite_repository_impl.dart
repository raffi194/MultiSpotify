import '../../domain/entities/favorite_entity.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../supabase/supabase_client.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final client = SupabaseService.client;

  @override
  Future<void> markFavorite(String songId) async {
    final userId = client.auth.currentUser!.id;

    await client.from('favorites').insert({
      'user_id': userId,
      'song_id': songId,
    });
  }

  @override
  Future<List<FavoriteEntity>> listFavorites() async {
    final userId = client.auth.currentUser!.id;

    final res =
        await client.from('favorites').select().eq('user_id', userId);

    return (res as List)
        .map(
          (e) => FavoriteEntity(
            id: e['id'],
            userId: e['user_id'],
            songId: e['song_id'],
          ),
        )
        .toList();
  }
}
