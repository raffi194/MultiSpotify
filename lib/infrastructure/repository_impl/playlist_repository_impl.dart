import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/playlist_entity.dart';
import '../../domain/entities/song_entity.dart';
import '../../domain/repositories/playlist_repository.dart';
import '../dto/playlist_dto.dart';
import '../dto/song_dto.dart';
import '../supabase/supabase_client.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final client = SupabaseService.client;

  @override
  Future<void> createPlaylist(String name, String description) async {
    final user = client.auth.currentUser;
    await client.from('playlists').insert({
      'user_id': user!.id,
      'name': name,
      'description': description,
    });
  }

  @override
  Future<void> updatePlaylist(String id, String description) async {
    await client
        .from('playlists')
        .update({'description': description}).eq('id', id);
  }

  @override
  Future<void> deletePlaylist(String id) async {
    await client.from('playlists').delete().eq('id', id);
  }

  @override
  Future<List<PlaylistEntity>> listPlaylists(String userId) async {
    final res = await client.from('playlists').select().eq('user_id', userId);

    return (res as List)
        .map((e) => PlaylistDto.fromJson(e))
        .map(
          (dto) => PlaylistEntity(
            id: dto.id,
            name: dto.name,
            description: dto.description,
            userId: dto.userId,
          ),
        )
        .toList();
  }

  @override
  Future<List<SongEntity>> listSongsInPlaylist(String playlistId) async {
    final res = await client
        .from('playlist_songs')
        .select('song_id, songs(*)')
        .eq('playlist_id', playlistId);

    return (res as List)
        .map((item) => item['songs'])
        .map((songJson) => SongDto.fromJson(songJson))
        .map(
          (dto) => SongEntity(
            id: dto.id,
            title: dto.title,
            artist: dto.artist,
            coverUrl: dto.coverUrl,
            audioUrl: dto.audioUrl,
          ),
        )
        .toList();
  }

  @override
  Future<void> addSong(String playlistId, String songId) async {
    await client.from('playlist_songs').insert({
      'playlist_id': playlistId,
      'song_id': songId,
    });
  }

  @override
  Future<void> removeSong(String playlistId, String songId) async {
    await client
        .from('playlist_songs')
        .delete()
        .eq('playlist_id', playlistId)
        .eq('song_id', songId);
  }
}
