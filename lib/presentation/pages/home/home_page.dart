import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../widgets/navbar_bottom.dart';
import '../../widgets/song_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(songsControllerProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final songs = ref.watch(songsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      bottomNavigationBar: const NavbarBottom(index: 0),
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
