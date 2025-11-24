import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// IMPORT YANG BENAR (provider ada di sini)
import '../../core/di/providers.dart';

// PAGES
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/songs/all_songs_page.dart';
import '../../presentation/pages/songs/song_detail_page.dart';
import '../../presentation/pages/playlist/playlist_list_page.dart';
import '../../presentation/pages/playlist/playlist_detail_page.dart';
import '../../presentation/pages/favorites/favorites_page.dart';
import '../../presentation/pages/admin/add_song_page.dart';
import '../../presentation/pages/playlist/playlist_editor_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',

    redirect: (context, state) {
      final user = ref.read(authControllerProvider);

      final loggingIn = state.matchedLocation == '/login';
      final registering = state.matchedLocation == '/register';

      // Belum login
      if (user == null) {
        if (!loggingIn && !registering) return '/login';
        return null;
      }

      // Sudah login
      if (user != null) {
        if (loggingIn || registering) return '/';
      }

      return null;
    },

    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      GoRoute(path: '/', builder: (_, __) => const HomePage()),
      GoRoute(path: '/songs', builder: (_, __) => const AllSongsPage()),
      GoRoute(
        path: '/songs/:id',
        builder: (_, state) =>
            SongDetailPage(songId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/playlists', builder: (_, __) => const PlaylistListPage()),
      GoRoute(
        path: '/playlist/:id',
        builder: (_, state) =>
            PlaylistDetailPage(playlistId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/favorites', builder: (_, __) => const FavoritesPage()),
      GoRoute(
        path: '/playlist-editor',
        builder: (_, __) => const PlaylistEditorPage(),
      ),
      GoRoute(path: '/admin/add-song', builder: (_, __) => const AddSongPage()),
    ],
  );
});
