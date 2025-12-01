import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/providers.dart';

import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/profile/profile_page.dart';
import '../../presentation/pages/search/search_page.dart'; // ADD
import '../../domain/entities/song_entity.dart';

import '../../presentation/pages/songs/all_songs_page.dart';
import '../../presentation/pages/songs/song_detail_page.dart';
import '../../presentation/pages/playlist/playlist_list_page.dart';
import '../../presentation/pages/playlist/playlist_detail_page.dart';
import '../../presentation/pages/admin/add_song_page.dart';
import '../../presentation/pages/playlist/playlist_editor_page.dart';
import '../../presentation/widgets/player/full_player_page.dart';
import '../../presentation/pages/playlist/playlist_create_page.dart';
import '../../presentation/pages/playlist/playlist_edit_page.dart';
import '../../presentation/pages/songs/song_upload_page.dart';
import '../../presentation/pages/songs/my_songs_page.dart';
import '../../presentation/pages/songs/my_song_detail_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final user = ref.read(authControllerProvider);

      final loggingIn = state.matchedLocation == '/login';
      final registering = state.matchedLocation == '/register';

      if (user == null) {
        if (!loggingIn && !registering) return '/login';
        return null;
      }

      if (user != null) {
        if (loggingIn || registering) return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      GoRoute(path: '/', builder: (_, __) => const HomePage()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
      GoRoute(path: '/search', builder: (_, __) => const SearchPage()),
      GoRoute(path: '/songs', builder: (_, __) => const AllSongsPage()),
      GoRoute(
        path: '/songs/:id',
        builder: (_, state) =>
            SongDetailPage(songId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/song-upload',
        builder: (_, __) => const SongUploadPage(),
      ),
      GoRoute(path: '/playlists', builder: (_, __) => const PlaylistListPage()),
      GoRoute(
        path: '/playlist/:id',
        builder: (_, state) =>
            PlaylistDetailPage(playlistId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/playlist-create',
        builder: (_, __) => const PlaylistCreatePage(),
      ),
      GoRoute(
        path: '/my-songs',
        builder: (_, __) => const MySongsPage(),
      ),
      GoRoute(
        path: '/my-song-detail',
        builder: (_, state) {
          final song = state.extra as SongEntity;
          return MySongDetailPage(song: song);
        },
      ),
      GoRoute(
        path: '/playlist-edit/:id',
        builder: (_, state) => PlaylistEditPage(
          playlistId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(path: '/admin/add-song', builder: (_, __) => const AddSongPage()),
      GoRoute(path: '/player', builder: (_, __) => const FullPlayerPage()),
    ],
  );
});
