import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/providers.dart';
import '../widgets/create_playlist_modal.dart';
import '../widgets/add_to_playlist_modal.dart';

class FavoriteHelper {
  static Future<void> handleFavorite(
    BuildContext context,
    WidgetRef ref,
    String songId,
  ) async {
    final user = ref.read(authControllerProvider);
    final userId = user?.id ?? '';

    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan login terlebih dahulu")),
      );
      return;
    }

    final playlists = ref.read(playlistControllerProvider).value ?? [];

    if (playlists.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => CreatePlaylistModal(
          onSubmit: (name, desc) async {
            await ref
                .read(playlistControllerProvider.notifier)
                .create(name, desc, userId);

            await ref
                .read(playlistControllerProvider.notifier)
                .loadPlaylists(userId);

            final updatedPlaylist =
                ref.read(playlistControllerProvider).value?.first;

            if (updatedPlaylist != null) {
              await ref
                  .read(playlistControllerProvider.notifier)
                  .addToPlaylist(updatedPlaylist.id, songId, userId);
            }
          },
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AddToPlaylistModal(
        playlists: playlists,
        onSelect: (pid) async {
          await ref
              .read(playlistControllerProvider.notifier)
              .addToPlaylist(pid, songId, userId);
          Navigator.pop(context);
        },
      ),
    );
  }
}
