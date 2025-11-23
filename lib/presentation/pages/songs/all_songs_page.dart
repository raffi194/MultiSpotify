import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../widgets/navbar_bottom.dart';
import '../../widgets/song_card.dart';

class AllSongsPage extends ConsumerWidget {
  const AllSongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Semua Lagu")),
      bottomNavigationBar: const NavbarBottom(index: 1),
      body: songs.when(
        data: (list) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: list.map((song) => SongCard(song: song)).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text(e.toString())),
      ),
    );
  }
}
