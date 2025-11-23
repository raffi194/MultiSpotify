import '../../domain/repositories/playlist_repository.dart';

class DeletePlaylistUsecase {
  final PlaylistRepository repo;
  DeletePlaylistUsecase(this.repo);

  Future execute(String id) {
    return repo.deletePlaylist(id);
  }
}
