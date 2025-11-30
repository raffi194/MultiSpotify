import '../../domain/repositories/playlist_repository.dart';

class RemoveSongFromPlaylistUsecase {
  final PlaylistRepository repo;
  RemoveSongFromPlaylistUsecase(this.repo);

  Future execute(String playlistId, String songId) {
    return repo.removeSong(playlistId, songId);
  }
}
