import '../../domain/repositories/playlist_repository.dart';

class UpdatePlaylistUsecase {
  final PlaylistRepository repo;
  UpdatePlaylistUsecase(this.repo);

  Future execute(String id, String description) {
    return repo.updatePlaylist(id, description);
  }
}
