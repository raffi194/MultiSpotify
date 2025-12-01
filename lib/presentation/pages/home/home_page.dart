import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../controllers/songs_controller.dart';

// Widgets
import '../../widgets/song/song_card.dart';
import '../../widgets/playlist/playlist_card.dart';
import '../../widgets/playlist/playlist_shimmer.dart';
import '../../widgets/player/mini_player.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  double headerOpacity = 1.0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final user = ref.read(authControllerProvider);

      // Load playlist
      if (user != null) {
        await ref
            .read(playlistControllerProvider.notifier)
            .loadPlaylists(user.id);

        await ref
            .read(playlistControllerProvider.notifier)
            .loadPlaylistCovers(user.id);
      }

      // Load songs global
      await ref.read(songsControllerProvider.notifier).loadAllSongs();

      // Load songs milik user
      if (user != null) {
        await ref
            .read(songsControllerProvider.notifier)
            .loadMySongs(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final playlists = ref.watch(playlistControllerProvider);
    final songsAsync = ref.watch(songsControllerProvider);
    final songsController = ref.read(songsControllerProvider.notifier);
    final user = ref.watch(authControllerProvider);

    final allSongs = songsController.allSongs;
    final mySongs = songsController.mySongs;

    final initial =
        (user?.email.isNotEmpty ?? false) ? user!.email[0].toUpperCase() : "?";

    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll.metrics.axis == Axis.vertical) {
            setState(() {
              headerOpacity =
                  (1 - (scroll.metrics.pixels / 120)).clamp(0.0, 1.0);
            });
          }
          return false;
        },
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              _buildHeader(initial),
              _buildSearchBar(),

              // ----------------------------------------------------------
              // PLAYLIST SECTION
              // ----------------------------------------------------------
              _playlistTitle(),
              _playlistList(playlists),

              // ----------------------------------------------------------
              // LAGU TERBARU (GLOBAL)
              // ----------------------------------------------------------
              _sectionTitle("Lagu Terbaru"),
              _latestSongs(songsAsync, allSongs),

              // ----------------------------------------------------------
              // LAGU YANG SAYA UPLOAD
              // ----------------------------------------------------------
              _sectionTitle("Lagu yang Saya Upload"),
              _mySongsList(mySongs),

              const SliverToBoxAdapter(child: SizedBox(height: 90)),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const MiniPlayer(),
    );
  }

  // ----------------------------------------------------------
  // HEADER PROFILE
  // ----------------------------------------------------------
  SliverToBoxAdapter _buildHeader(String initial) {
    return SliverToBoxAdapter(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: headerOpacity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selamat Datang",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Dengarkan Musik Favoritmu",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              GestureDetector(
                onTap: () => context.go('/profile'),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white24,
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // SEARCH BAR
  // ----------------------------------------------------------
  SliverToBoxAdapter _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: GestureDetector(
          onTap: () => context.go('/search'),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.white60),
                const SizedBox(width: 10),
                Text(
                  "Cari lagu, artis, playlist...",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // PLAYLIST TITLE
  // ----------------------------------------------------------
  SliverToBoxAdapter _playlistTitle() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Playlist Kamu",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/playlists'),
              child: const Text(
                "Kelola",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // PLAYLIST LIST
  // ----------------------------------------------------------
  Widget _playlistList(AsyncValue playlists) {
    return playlists.when(
      data: (data) {
        if (data.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Belum ada playlist.",
                style: TextStyle(color: Colors.white60),
              ),
            ),
          );
        }

        return SliverToBoxAdapter(
          child: SizedBox(
            height: 170,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, i) {
                final coverUrl = ref
                    .watch(playlistControllerProvider.notifier)
                    .playlistCovers[data[i].id];

                return PlaylistCard(
                  playlist: data[i],
                  coverUrl: coverUrl,
                );
              },
            ),
          ),
        );
      },
      loading: () => SliverToBoxAdapter(
        child: SizedBox(
          height: 170,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (_, __) => const PlaylistShimmer(),
          ),
        ),
      ),
      error: (_, __) => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Gagal memuat playlist",
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // LAGU TERBARU (GLOBAL)
  // ----------------------------------------------------------
  Widget _latestSongs(AsyncValue songsAsync, List allSongs) {
    return songsAsync.when(
      loading: () => const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (_, __) => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Gagal memuat lagu terbaru",
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ),
      data: (_) {
        if (allSongs.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Belum ada lagu.",
                style: TextStyle(color: Colors.white54),
              ),
            ),
          );
        }

        return SliverList.separated(
          itemCount: allSongs.length,
          separatorBuilder: (_, __) =>
              const Divider(color: Colors.white12, height: 1),
          itemBuilder: (context, i) {
            return SongCard(song: allSongs[i]);
          },
        );
      },
    );
  }

  // ----------------------------------------------------------
  // LAGU SAYA
  // ----------------------------------------------------------
  Widget _mySongsList(List mySongs) {
    if (mySongs.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "Kamu belum mengupload lagu apapun.",
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    return SliverList.separated(
      itemCount: mySongs.length,
      separatorBuilder: (_, __) =>
          const Divider(color: Colors.white12, height: 1),
      itemBuilder: (context, i) {
        return SongCard(song: mySongs[i]);
      },
    );
  }

  // ----------------------------------------------------------
  // SECTION TITLE
  // ----------------------------------------------------------
  Widget _sectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
