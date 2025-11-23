import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/song_entity.dart';
import '../../domain/repositories/song_repository.dart';
import '../dto/song_dto.dart';
import '../supabase/supabase_client.dart';

class SongRepositoryImpl implements SongRepository {
  final client = SupabaseService.client;

  @override
  Future<List<SongEntity>> fetchAll() async {
    final response = await client.from('songs').select().order('created_at');

    return (response as List<dynamic>)
        .map((e) => SongDto.fromJson(e))
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
  Future<void> uploadSong(SongEntity song) async {
    await client.from('songs').insert({
      'title': song.title,
      'artist': song.artist,
      'cover_url': song.coverUrl,
      'audio_url': song.audioUrl,
    });
  }

  @override
  Future<void> deleteSong(String id) async {
    await client.from('songs').delete().eq('id', id);
  }
}
