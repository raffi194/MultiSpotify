import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../widgets/navbar_bottom.dart';
import '../../widgets/song/song_card.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  @override
  void initState() {
    super.initState();

    // Memuat ulang data favorit dan lagu menggunakan method yang BENAR
    Future.microtask(() {
      ref.read(favoriteControllerProvider.notifier).fetchFavorites();
      ref.read(songsControllerProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesAsync = ref.watch(favoriteControllerProvider);
    final songsAsync = ref.watch(songsControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
      appBar: AppBar(
        title: const Text("Favorit"),
        backgroundColor: const Color(0xFF121212),
      ),
      bottomNavigationBar: const NavbarBottom(index: 3),
      body: favoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(
          child: Text(
            "Gagal memuat favorit: $err",
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
        data: (favoriteList) {
          return songsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, st) => Center(
              child: Text(
                "Gagal memuat lagu: $err",
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
            data: (songs) {
              final favSongs = songs
                  .where((song) =>
                      favoriteList.any((fav) => fav.songId == song.id))
                  .toList();

              if (favSongs.isEmpty) {
                return const Center(
                  child: Text(
                    "Belum ada lagu favorit.",
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favSongs.length,
                itemBuilder: (_, i) => SongCard(song: favSongs[i]),
              );
            },
          );
        },
      ),
    );
  }
}
