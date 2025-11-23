import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../controllers/playlist_controller.dart';
import '../../widgets/playlist_card.dart';
import '../../widgets/navbar_bottom.dart';

class PlaylistListPage extends ConsumerStatefulWidget {
  const PlaylistListPage({super.key});

  @override
  ConsumerState<PlaylistListPage> createState() => _PlaylistListPageState();
}

class _PlaylistListPageState extends ConsumerState<PlaylistListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final user = ref.read(authControllerProvider);
      if (user != null) {
        ref
            .read(playlistControllerProvider.notifier)
            .loadPlaylists(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final playlists = ref.watch(playlistControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Playlist Saya")),
      bottomNavigationBar: const NavbarBottom(index: 2),
      body: playlists.when(
        data: (list) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: list.map((p) => PlaylistCard(playlist: p)).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text(e.toString())),
      ),
    );
  }
}
