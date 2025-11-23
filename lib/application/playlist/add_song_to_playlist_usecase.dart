import '../../domain/repositories/playlist_repository.dart';

class AddSongToPlaylistUsecase {
  final PlaylistRepository repo;
  AddSongToPlaylistUsecase(this.repo);

  Future execute(String playlistId, String songId) {
    return repo.addSong(playlistId, songId);
  }
}
