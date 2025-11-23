import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/song_entity.dart';
import '../../application/songs/fetch_all_songs_usecase.dart';
import '../../application/songs/upload_song_usecase.dart';

class SongsController extends StateNotifier<AsyncValue<List<SongEntity>>> {
  final FetchAllSongsUsecase fetchSongs;
  final UploadSongUsecase uploadSongUsecase;
  final Ref ref;

  SongsController(
    this.fetchSongs,
    this.uploadSongUsecase, {
    required this.ref,
  }) : super(const AsyncValue.loading());

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final data = await fetchSongs.execute();
      state = AsyncValue.data(data);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> uploadSong(SongEntity song) async {
    await uploadSongUsecase.execute(song);
    await load();
  }
}
