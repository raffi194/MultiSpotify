import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../widgets/playlist_card.dart';

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
        ref.read(playlistControllerProvider.notifier).loadPlaylists(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final playlists = ref.watch(playlistControllerProvider);
    final user = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
      appBar: AppBar(
        title: const Text("Kelola Playlist"),
        backgroundColor: const Color(0xFF0C0C0C),
      ),

      // ==========================================================
      // FLOATING BUTTON → BUAT PLAYLIST
      // ==========================================================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/playlist-create'),
        backgroundColor: Colors.greenAccent.shade700,
        icon: const Icon(Icons.add),
        label: const Text("Buat Playlist"),
      ),

      body: playlists.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, s) => Center(
          child: Text(
            "Gagal memuat playlist",
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),

        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada playlist.\nBuat playlist pertamamu!",
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: list.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.82,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemBuilder: (context, i) {
              final p = list[i];

              return Stack(
                children: [
                  PlaylistCard(playlist: p),

                  Positioned(
                    right: 6,
                    top: 6,
                    child: PopupMenuButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white70),
                      color: const Color(0xFF1A1A1A),

                      onSelected: (value) async {
                        if (value == "delete") {
                          await ref
                              .read(playlistControllerProvider.notifier)
                              .delete(p.id, user!.id);
                        }

                        if (value == "edit") {
                          context.push('/playlist-edit/${p.id}');
                        }
                      },

                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: "edit",
                          child: Text(
                            "Edit Playlist",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const PopupMenuItem(
                          value: "delete",
                          child: Text(
                            "Hapus Playlist",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
