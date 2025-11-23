import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../../domain/entities/song_entity.dart';
import '../controllers/playlist_controller.dart';
import 'add_to_playlist_modal.dart';
import 'create_playlist_modal.dart';
import 'favorite_button.dart';
import 'package:go_router/go_router.dart';

class SongCard extends ConsumerWidget {
  final SongEntity song;

  const SongCard({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);
    final userId = user?.id ?? '';

    return InkWell(
      onTap: () => context.push('/songs/${song.id}'),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                song.coverUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Text(
                "${song.title} — ${song.artist}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            FavoriteButton(
              onTap: () async {
                final playlists =
                    ref.read(playlistControllerProvider).value ?? [];

                if (playlists.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (_) => CreatePlaylistModal(
                      onSubmit: (name, desc) async {
                        await ref
                            .read(playlistControllerProvider.notifier)
                            .create(name, desc, userId);
                      },
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => AddToPlaylistModal(
                      playlists: playlists,
                      onSelect: (pid) async {
                        await ref
                            .read(playlistControllerProvider.notifier)
                            .addToPlaylist(pid, song.id, userId);
                        Navigator.pop(context);
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
