import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../widgets/song_card.dart';
import '../../widgets/navbar_bottom.dart';

class PlaylistDetailPage extends ConsumerStatefulWidget {
  final String playlistId;

  const PlaylistDetailPage({
    super.key,
    required this.playlistId,
  });

  @override
  ConsumerState<PlaylistDetailPage> createState() =>
      _PlaylistDetailPageState();
}

class _PlaylistDetailPageState
    extends ConsumerState<PlaylistDetailPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final user = ref.read(authControllerProvider);
      if (user != null) {
        await ref
            .read(playlistControllerProvider.notifier)
            .loadSongsInPlaylist(widget.playlistId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final playlistSongs = ref.watch(playlistControllerProviderSongs);

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Playlist")),
      bottomNavigationBar: const NavbarBottom(index: 2),
      body: playlistSongs.when(
        data: (songs) {
          if (songs.isEmpty) {
            return const Center(
              child: Text(
                "Tidak ada lagu di playlist ini",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: songs.map((song) => SongCard(song: song)).toList(),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (e, s) => Center(
          child: Text(
            "Terjadi kesalahan: $e",
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }
}
