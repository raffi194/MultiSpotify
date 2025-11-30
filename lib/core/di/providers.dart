import 'package:flutter_riverpod/flutter_riverpod.dart';

//
// =============================================================
// ENTITY IMPORTS
// =============================================================
import '../../domain/entities/song_entity.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/entities/playlist_entity.dart';
import '../../domain/entities/user_entity.dart'; // ← WAJIB, yang tadi hilang

//
// =============================================================
// DOMAIN REPOSITORIES
// =============================================================
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/song_repository.dart';
import '../../domain/repositories/playlist_repository.dart';
import '../../domain/repositories/favorite_repository.dart';

//
// =============================================================
// INFRASTRUCTURE IMPLEMENTATIONS
// =============================================================
import '../../infrastructure/repository_impl/auth_repository_impl.dart';
import '../../infrastructure/repository_impl/song_repository_impl.dart';
import '../../infrastructure/repository_impl/playlist_repository_impl.dart';
import '../../infrastructure/repository_impl/favorite_repository_impl.dart';

//
// =============================================================
// USECASES
// =============================================================

// AUTH (langsung nanti dibuat di controller)
import '../../application/auth/login_usecase.dart';
import '../../application/auth/register_usecase.dart';
import '../../application/auth/get_current_user_usecase.dart';

// SONGS
import '../../application/songs/fetch_all_songs_usecase.dart';
import '../../application/songs/upload_song_usecase.dart';
import '../../presentation/pages/songs/search_songs_usecase.dart'; // ← ADD
import '../../infrastructure/local/search_local_datasource.dart';

// PLAYLIST
import '../../application/playlist/list_playlist_user_usecase.dart';
import '../../application/playlist/list_song_in_playlist_usecase.dart';
import '../../application/playlist/create_playlist_usecase.dart';
import '../../application/playlist/add_song_to_playlist_usecase.dart';

// FAVORITES
import '../../application/favorites/list_favorites_usecase.dart';
import '../../application/favorites/mark_favorite_usecase.dart';

//
// =============================================================
// CONTROLLERS
// =============================================================
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/songs_controller.dart';
import '../../presentation/controllers/playlist_controller.dart';
import '../../presentation/controllers/favorite_controller.dart';

//
// =============================================================
// REPOSITORY PROVIDERS
// =============================================================
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final songRepositoryProvider = Provider<SongRepository>((ref) {
  return SongRepositoryImpl();
});

final playlistRepositoryProvider = Provider<PlaylistRepository>((ref) {
  return PlaylistRepositoryImpl();
});

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return FavoriteRepositoryImpl();
});

//
// =============================================================
// USECASE PROVIDERS (Songs, Playlist, Favorites)
// =============================================================

// SONGS
final fetchAllSongsUsecaseProvider = Provider(
  (ref) => FetchAllSongsUsecase(ref.watch(songRepositoryProvider)),
);

final uploadSongUsecaseProvider = Provider(
  (ref) => UploadSongUsecase(ref.watch(songRepositoryProvider)),
);

// PLAYLIST
final listPlaylistUserUsecaseProvider = Provider(
  (ref) => ListPlaylistUserUsecase(ref.watch(playlistRepositoryProvider)),
);

final listSongsInPlaylistUsecaseProvider = Provider(
  (ref) => ListSongsInPlaylistUsecase(ref.watch(playlistRepositoryProvider)),
);

final createPlaylistUsecaseProvider = Provider(
  (ref) => CreatePlaylistUsecase(ref.watch(playlistRepositoryProvider)),
);

final addSongToPlaylistUsecaseProvider = Provider(
  (ref) => AddSongToPlaylistUsecase(ref.watch(playlistRepositoryProvider)),
);

// FAVORITES
final listFavoritesUsecaseProvider = Provider(
  (ref) => ListFavoritesUsecase(ref.watch(favoriteRepositoryProvider)),
);

final markFavoriteUsecaseProvider = Provider(
  (ref) => MarkFavoriteUsecase(ref.watch(favoriteRepositoryProvider)),
);

//
// =============================================================
// CONTROLLER PROVIDERS
// =============================================================

// AUTH CONTROLLER (tanpa usecase providers — langsung instance usecase)
final authControllerProvider =
    StateNotifierProvider<AuthController, UserEntity?>((ref) {
  final repo = ref.watch(authRepositoryProvider);

  return AuthController(
    loginUsecase: LoginUsecase(repo),
    registerUsecase: RegisterUsecase(repo),
    getCurrentUserUsecase: GetCurrentUserUsecase(repo),
  );
});

// SONGS CONTROLLER
final songsControllerProvider =
    StateNotifierProvider<SongsController, AsyncValue<List<SongEntity>>>((ref) {
  return SongsController(
    ref.watch(fetchAllSongsUsecaseProvider),
    ref.watch(uploadSongUsecaseProvider),
    ref.watch(searchSongsUsecaseProvider),
    SearchLocalDatasource(),              // ADD
    ref: ref,
  );
});

final searchSongsUsecaseProvider = Provider(
  (ref) => SearchSongsUsecase(ref.watch(songRepositoryProvider)),
);


// PLAYLIST CONTROLLER
final playlistControllerProvider =
    StateNotifierProvider<PlaylistController, AsyncValue<List<PlaylistEntity>>>((ref) {
  return PlaylistController(
    listPlaylistUser: ref.watch(listPlaylistUserUsecaseProvider),
    createPlaylist: ref.watch(createPlaylistUsecaseProvider),
    addSongToPlaylist: ref.watch(addSongToPlaylistUsecaseProvider),
    listSongsInPlaylist: ref.watch(listSongsInPlaylistUsecaseProvider),
    ref: ref,
  );
});

// FAVORITE CONTROLLER
final favoriteControllerProvider =
    StateNotifierProvider<FavoriteController, AsyncValue<List<FavoriteEntity>>>((ref) {
  return FavoriteController(
    listFavorites: ref.watch(listFavoritesUsecaseProvider),
    markFavorite: ref.watch(markFavoriteUsecaseProvider),
  );
});

// PLAYLIST SONGS CONTROLLER (untuk detail playlist)
final playlistControllerProviderSongs =
    StateNotifierProvider<PlaylistSongsController, AsyncValue<List<SongEntity>>>((ref) {
  return PlaylistSongsController();
});
