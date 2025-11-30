import '../../domain/repositories/playlist_repository.dart';

class CreatePlaylistUsecase {
  final PlaylistRepository repo;
  CreatePlaylistUsecase(this.repo);

  Future execute(String name, String description) {
    return repo.createPlaylist(name, description);
  }
}
