import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/providers.dart';
import '../../widgets/song/song_card.dart';
import '../../widgets/playlist/playlist_card.dart';
import '../../widgets/player/mini_player.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  double headerOpacity = 1.0;

  @override
  Widget build(BuildContext context) {
    final songs = ref.watch(songsControllerProvider);
    final playlists = ref.watch(playlistControllerProvider);
    final user = ref.watch(authControllerProvider);

    final initial = (user?.email.isNotEmpty ?? false)
        ? user!.email[0].toUpperCase()
        : "?";

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
              // HEADER
              SliverToBoxAdapter(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: headerOpacity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // TEXT KIRI
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

                        // PROFILE BUTTON
                        GestureDetector(
                          onTapDown: (_) => setState(() => headerOpacity = 0.7),
                          onTapUp: (_) => setState(() => headerOpacity = 1.0),
                          onTap: () => _openProfileMenu(context, initial),
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 150),
                            scale: headerOpacity == 1 ? 1 : 0.9,
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // SEARCH BAR (TAP → /search)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: [
                      const SizedBox(height: 18),
                      GestureDetector(
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
                    ],
                  ),
                ),
              ),

              // PLAYLIST SECTION
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Playlist Kamu",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Lihat semua",
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              playlists.when(
                data: (data) {
                  if (data.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          "Belum ada playlist.",
                          style: TextStyle(color: Colors.white60),
                        ),
                      ),
                    );
                  }

                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: 150,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 14),
                        itemBuilder: (context, i) {
                          return PlaylistCard(playlist: data[i]);
                        },
                      ),
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                error: (err, st) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Gagal memuat playlist",
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ),
              ),

              // RECOMMENDED SONGS
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Rekomendasi Untuk Kamu",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              songs.when(
                data: (list) {
                  if (list.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Belum ada lagu.",
                          style: TextStyle(color: Colors.white60),
                        ),
                      ),
                    );
                  }

                  return SliverList.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(
                      color: Colors.white12,
                      height: 1,
                    ),
                    itemBuilder: (context, i) {
                      return SongCard(song: list[i]);
                    },
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                error: (err, st) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Gagal memuat lagu",
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 90)),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const MiniPlayer(),
    );
  }

  // ============================================================
  // BOTTOM SHEET ala Spotify
  // ============================================================
  void _openProfileMenu(BuildContext context, String initial) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              ListTile(
                onTap: () => context.go('/profile'),
                leading: CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Text(
                    initial,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: const Text(
                  "Profil",
                  style: TextStyle(color: Colors.white),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text(
                  "Pengaturan",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),

              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () async {
                  await ref.read(authControllerProvider.notifier).logout();
                  Navigator.pop(context);
                  context.go('/login');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
