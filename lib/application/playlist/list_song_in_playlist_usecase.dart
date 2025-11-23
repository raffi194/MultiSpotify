import '../../domain/repositories/playlist_repository.dart';

class ListSongsInPlaylistUsecase {
  final PlaylistRepository repo;
  ListSongsInPlaylistUsecase(this.repo);

  Future execute(String playlistId) {
    return repo.listSongsInPlaylist(playlistId);
  }
}
