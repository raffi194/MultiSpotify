import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/song_entity.dart';
import '../../domain/repositories/song_repository.dart';
import '../dto/song_dto.dart';

class SongRepositoryImpl implements SongRepository {
  final SupabaseClient client = Supabase.instance.client;

  @override
  Future<List<SongEntity>> fetchAll() async {
    final response = await client
        .from('songs')
        .select('*')
        .order('created_at', ascending: false);

    if (response == null || response is! List) {
      return [];
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
  Future<List<SongEntity>> searchSongs(String keyword) async {
    if (keyword.trim().isEmpty) return [];

    try {
      final response = await client
          .from('songs')
          .select('*')
          .textSearch('title', "'$keyword'") // FTS (Cepat)
          .order('created_at', ascending: false);

      if (response != null && response is List && response.isNotEmpty) {
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
    } catch (_) {
      // fallback ke ILIKE jika FTS tidak aktif
    }

    final fallback = await client
        .from('songs')
        .select('*')
        .or("title.ilike.%$keyword%,artist.ilike.%$keyword%")
        .order('created_at', ascending: false);

    if (fallback == null || fallback is! List) {
      return [];
    }

    return fallback
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
    final res = await client.from('songs').delete().eq('id', id);

    if (res is PostgrestException) {
      throw Exception("Gagal delete lagu: ${res.message}");
    }
  }

  @override
  Future<List<String>> searchArtists(String keyword) async {
    if (keyword.trim().isEmpty) return [];

    final response = await client
        .from('songs')
        .select('artist')
        .ilike('artist', '%$keyword%')
        .order('artist', ascending: true);

    if (response == null || response is! List) return [];

    final artists =
        response.map((row) => row['artist'].toString()).toSet().toList();

    return artists;
  }
}
