import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';   // ← WAJIB, satu-satunya import provider
import '../../widgets/navbar_bottom.dart';
import '../../widgets/song_card.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(favoriteControllerProvider.notifier).load();
      ref.read(songsControllerProvider.notifier).load(); // optional: pastikan lagu ter-load
    });
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoriteControllerProvider);
    final allSongs = ref.watch(songsControllerProvider).value ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text("Favorit")),
      bottomNavigationBar: const NavbarBottom(index: 3),
      body: favorites.when(
        data: (list) {
          final favSongs = allSongs
              .where((song) => list.any((f) => f.songId == song.id))
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: favSongs.map((s) => SongCard(song: s)).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text(e.toString())),
      ),
    );
  }
}
