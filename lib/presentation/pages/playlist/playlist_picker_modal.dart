import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';

class PlaylistPickerModal extends ConsumerWidget {
  final String songId;

  const PlaylistPickerModal({
    super.key,
    required this.songId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlists = ref.watch(playlistControllerProvider);
    final user = ref.watch(authControllerProvider);

    if (user == null) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            "Anda belum login.",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return SizedBox(
      height: 420,
      child: playlists.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada playlist.",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView(
            children: list.map((p) {
              return ListTile(
                title:
                    Text(p.name, style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                  p.description ?? "",
                  style: const TextStyle(color: Colors.white54),
                ),
                onTap: () async {
                  await ref
                      .read(playlistControllerProvider.notifier)
                      .addToPlaylist(
                        p.id,
                        songId,
                        user.id, // sudah aman
                      );

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Ditambahkan ke ${p.name}")),
                  );
                },
              );
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(
          child: Text(
            "Error: $e",
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }
}
