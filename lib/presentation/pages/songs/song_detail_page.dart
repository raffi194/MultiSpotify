import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../helpers/favorite_helper.dart';
import '../../widgets/audio_player_widget.dart';
import '../../widgets/navbar_bottom.dart';
import '../playlist/playlist_picker_modal.dart';

class SongDetailPage extends ConsumerWidget {
  final String songId;
  const SongDetailPage({super.key, required this.songId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songsControllerProvider);

    final songList = songs.value ?? [];
    final song = songList.where((e) => e.id == songId).isNotEmpty
        ? songList.firstWhere((e) => e.id == songId)
        : null;

    if (song == null) {
      return const Scaffold(
        body: Center(child: Text("Lagu tidak ditemukan")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(song.title)),
      bottomNavigationBar: const NavbarBottom(index: 1),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(song.coverUrl, height: 240),
            const SizedBox(height: 20),
            Text(
              song.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(song.artist, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),

            AudioPlayerWidget(url: song.audioUrl),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () =>
                  FavoriteHelper.handleFavorite(context, ref, songId),
              icon: const Icon(Icons.favorite),
              label: const Text("Favoritkan"),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.black87,
                  builder: (_) =>
                      PlaylistPickerModal(songId: song.id),
                );
              },
              icon: const Icon(Icons.playlist_add),
              label: const Text("Tambahkan ke Playlist"),
            ),
          ],
        ),
      ),
    );
  }
}
