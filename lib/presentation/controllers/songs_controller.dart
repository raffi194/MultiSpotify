import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/song_entity.dart';
import '../../application/songs/fetch_all_songs_usecase.dart';
import '../../application/songs/upload_song_usecase.dart';
import '../../presentation/pages/songs/search_songs_usecase.dart'; // ← WAJIB, yang benar
import '../../infrastructure/local/search_local_datasource.dart';
import '../../core/di/providers.dart'; // ← WAJIB
import 'dart:async';

class SongsController extends StateNotifier<AsyncValue<List<SongEntity>>> {
  final FetchAllSongsUsecase fetchSongs;
  final UploadSongUsecase uploadSongUsecase;
  final SearchSongsUsecase searchSongsUsecase;
  final SearchLocalDatasource local;

  Timer? debounceTimer;

  List<String> recentSearch = [];
  String searchCategory = "song"; // song, artist

  final Ref ref;

  SongsController(
    this.fetchSongs,
    this.uploadSongUsecase,
    this.searchSongsUsecase,
    this.local, {
    required this.ref,
  }) : super(const AsyncValue.loading()) {
    loadRecent();
    load();
  }

  Future<void> loadRecent() async {
    recentSearch = await local.getRecent();
  }

  void updateCategory(String cat) {
    searchCategory = cat;
  }

  Future<void> searchDebounce(String keyword) async {
    debounceTimer?.cancel();
    debounceTimer = Timer(const Duration(milliseconds: 300), () {
      search(keyword);
    });
  }

  Future<void> uploadSong(SongEntity song) async {
    try {
      state = const AsyncValue.loading();

      await uploadSongUsecase.execute(song);

      // Refresh list setelah upload
      final data = await fetchSongs.execute();
      state = AsyncValue.data(data);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final data = await fetchSongs.execute();
      state = AsyncValue.data(data);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> search(String keyword) async {
    if (keyword.isEmpty) {
      state = AsyncValue.data([]);
      return;
    }

    local.addRecent(keyword);

    state = const AsyncValue.loading();

    try {
      if (searchCategory == "song") {
        final results = await searchSongsUsecase.execute(keyword);
        state = AsyncValue.data(results);
      } else if (searchCategory == "artist") {
        final artists =
            await ref.read(songRepositoryProvider).searchArtists(keyword);

        final asSongs = artists
            .map((a) => SongEntity(
                  id: a,
                  title: "Artis: $a",
                  artist: a,
                  coverUrl: "",
                  audioUrl: "",
                ))
            .toList();

        state = AsyncValue.data(asSongs);
      }
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
