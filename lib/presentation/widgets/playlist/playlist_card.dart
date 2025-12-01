import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/playlist_entity.dart';
import '../../../core/di/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaylistCard extends ConsumerWidget {
  final PlaylistEntity playlist;
  final String? coverUrl;

  const PlaylistCard({
    super.key,
    required this.playlist,
    this.coverUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 140),
      scale: 1.0,
      child: InkWell(
        onLongPress: () => _openActionMenu(context, ref),
        onTap: () => context.push('/playlist/${playlist.id}'),
        child: Container(
          width: 150,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF181818),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // COVER
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: coverUrl != null
                    ? Image.network(
                        coverUrl!,
                        height: 95,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 95,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF242424),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.queue_music,
                          size: 42,
                          color: Colors.white54,
                        ),
                      ),
              ),
              const SizedBox(height: 12),

              // NAME
              Text(
                playlist.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // DESCRIPTION
              Text(
                playlist.description.isEmpty
                    ? "Tanpa deskripsi"
                    : playlist.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ACTION MENU (EDIT / DUPLICATE / DELETE)
  // ============================================================
  void _openActionMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF181818),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text("Edit Playlist",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/playlist-edit/${playlist.id}');
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.white),
                title: const Text("Duplikasi Playlist",
                    style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context);
                  final user = ref.read(authControllerProvider);
                  if (user == null) return;

                  await ref
                      .read(playlistControllerProvider.notifier)
                      .duplicate(playlist.id, user.id);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.redAccent),
                title: const Text("Hapus Playlist",
                    style: TextStyle(color: Colors.redAccent)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, ref);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final user = ref.read(authControllerProvider);
    if (user == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1B1B1B),
        title:
            const Text("Hapus Playlist", style: TextStyle(color: Colors.white)),
        content: Text(
          "Yakin ingin menghapus '${playlist.name}'?",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text("Batal", style: TextStyle(color: Colors.white70)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(playlistControllerProvider.notifier)
                  .delete(playlist.id, user!.id);
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }
}
