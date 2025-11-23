import '../../domain/repositories/playlist_repository.dart';

class ListPlaylistUserUsecase {
  final PlaylistRepository repo;
  ListPlaylistUserUsecase(this.repo);

  Future execute(String userId) {
    return repo.listPlaylists(userId);
  }
}
