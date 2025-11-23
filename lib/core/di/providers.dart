import 'package:flutter_riverpod/flutter_riverpod.dart';

// DOMAIN
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/song_repository.dart';
import '../../domain/repositories/playlist_repository.dart';
import '../../domain/repositories/favorite_repository.dart';

// INFRA
import '../../infrastructure/repository_impl/auth_repository_impl.dart';
import '../../infrastructure/repository_impl/song_repository_impl.dart';
import '../../infrastructure/repository_impl/playlist_repository_impl.dart';
import '../../infrastructure/repository_impl/favorite_repository_impl.dart';

// USECASES
import '../../application/auth/login_usecase.dart';
import '../../application/auth/register_usecase.dart';
import '../../application/auth/get_current_user_usecase.dart';

import '../../application/songs/fetch_all_songs_usecase.dart';
import '../../application/songs/upload_song_usecase.dart';

import '../../application/playlist/list_playlist_user_usecase.dart';
import '../../application/playlist/list_song_in_playlist_usecase.dart';
import '../../application/playlist/create_playlist_usecase.dart';
import '../../application/playlist/add_song_to_playlist_usecase.dart';

import '../../application/favorites/list_favorites_usecase.dart';
import '../../application/favorites/mark_favorite_usecase.dart';

// CONTROLLERS
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/songs_controller.dart';
import '../../presentation/controllers/playlist_controller.dart';
import '../../presentation/controllers/favorite_controller.dart';


/// =============================================================
/// REPOSITORIES
/// =============================================================
final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepositoryImpl());
final songRepositoryProvider = Provider<SongRepository>((ref) => SongRepositoryImpl());
final playlistRepositoryProvider = Provider<PlaylistRepository>((ref) => PlaylistRepositoryImpl());
final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) => FavoriteRepositoryImpl());


/// =============================================================
/// USECASES
/// =============================================================

// Auth
final loginUsecaseProvider = Provider((ref) => LoginUsecase(ref.watch(authRepositoryProvider)));
final registerUsecaseProvider = Provider((ref) => RegisterUsecase(ref.watch(authRepositoryProvider)));
final getCurrentUserUsecaseProvider = Provider((ref) => GetCurrentUserUsecase(ref.watch(authRepositoryProvider)));

// Songs
final fetchAllSongsUsecaseProvider =
    Provider((ref) => FetchAllSongsUsecase(ref.watch(songRepositoryProvider)));

final uploadSongUsecaseProvider =
    Provider((ref) => UploadSongUsecase(ref.watch(songRepositoryProvider)));


// Playlist
final listPlaylistUserUsecaseProvider =
    Provider((ref) => ListPlaylistUserUsecase(ref.watch(playlistRepositoryProvider)));

final listSongsInPlaylistUsecaseProvider =
    Provider((ref) => ListSongsInPlaylistUsecase(ref.watch(playlistRepositoryProvider)));

final createPlaylistUsecaseProvider =
    Provider((ref) => CreatePlaylistUsecase(ref.watch(playlistRepositoryProvider)));

final addSongToPlaylistUsecaseProvider =
    Provider((ref) => AddSongToPlaylistUsecase(ref.watch(playlistRepositoryProvider)));


// Favorites
final listFavoritesUsecaseProvider =
    Provider((ref) => ListFavoritesUsecase(ref.watch(favoriteRepositoryProvider)));

final markFavoriteUsecaseProvider =
    Provider((ref) => MarkFavoriteUsecase(ref.watch(favoriteRepositoryProvider)));


/// =============================================================
/// CONTROLLERS
/// =============================================================

final authControllerProvider = StateNotifierProvider<AuthController, dynamic>((ref) {
  return AuthController(
    loginUsecase: ref.watch(loginUsecaseProvider),
    registerUsecase: ref.watch(registerUsecaseProvider),
    getCurrentUserUsecase: ref.watch(getCurrentUserUsecaseProvider),
  );
});

final songsControllerProvider =
    StateNotifierProvider<SongsController, dynamic>((ref) {
  return SongsController(
    ref.watch(fetchAllSongsUsecaseProvider),
    ref.watch(uploadSongUsecaseProvider),
    ref: ref,
  );
});

final playlistControllerProvider =
    StateNotifierProvider<PlaylistController, dynamic>((ref) {
  return PlaylistController(
    listPlaylistUser: ref.watch(listPlaylistUserUsecaseProvider),
    createPlaylist: ref.watch(createPlaylistUsecaseProvider),
    addSongToPlaylist: ref.watch(addSongToPlaylistUsecaseProvider),
    listSongsInPlaylist: ref.watch(listSongsInPlaylistUsecaseProvider),
    ref: ref,
  );
});

final favoriteControllerProvider =
    StateNotifierProvider<FavoriteController, dynamic>((ref) {
  return FavoriteController(
    listFavorites: ref.watch(listFavoritesUsecaseProvider),
    markFavorite: ref.watch(markFavoriteUsecaseProvider),
  );
});
