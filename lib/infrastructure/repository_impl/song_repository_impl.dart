import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/song_entity.dart';
import '../../domain/repositories/song_repository.dart';
import '../dto/song_dto.dart';

class SongRepositoryImpl implements SongRepository {
  final SupabaseClient client = Supabase.instance.client;

  @override
  Future<List<SongEntity>> fetchAll() async {
    // Query aman + cek error
    final response = await client
        .from('songs')
        .select('*')
        .order('created_at', ascending: false);

    // Jika null → return empty (tidak crash)
    if (response == null) return [];

    if (response is! List) {
      throw Exception("Format data songs tidak valid");
    }

    return response
        .map((row) => SongDto.fromJson(row))
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
    final res = await client.from('songs').insert({
      'title': song.title,
      'artist': song.artist,
      'cover_url': song.coverUrl,
      'audio_url': song.audioUrl,
    });

    if (res is PostgrestException) {
      throw Exception("Gagal upload lagu: ${res.message}");
    }
  }

  @override
  Future<void> deleteSong(String id) async {
    final res =
        await client.from('songs').delete().eq('id', id);

    if (res is PostgrestException) {
      throw Exception("Gagal delete lagu: ${res.message}");
    }
  }
}
