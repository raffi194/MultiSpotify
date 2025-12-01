import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/player_controller.dart';

import '../../../core/di/providers.dart';
import '../../../domain/entities/song_entity.dart';

class MySongDetailPage extends ConsumerWidget {
  final SongEntity song;

  const MySongDetailPage({super.key, required this.song});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);

    final bool isOwner = user != null && user.id == song.uploaderId;

    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Detail Lagu"),
        actions: [
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => _openEditModal(context, ref),
            ),
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _confirmDelete(context, ref),
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Cover
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                song.coverUrl,
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              song.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Artist
            Text(
              song.artist,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 20),

            // Uploader
            Text(
              isOwner ? "Diupload oleh Saya" : "Uploader: ${song.uploaderId}",
              style: const TextStyle(color: Colors.white54),
            ),

            const SizedBox(height: 30),

            // Play Button
            ElevatedButton.icon(
              onPressed: () {
                ref.read(playerControllerProvider.notifier).playSong(song);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Memutar lagu...")),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text("Play Lagu"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.shade700,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================================================================
  // DELETE CONFIRMATION
  // ==================================================================
  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Hapus Lagu?", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Lagu akan dihapus permanen.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(songRepositoryProvider).deleteSong(song.id);
              Navigator.pop(context);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Lagu berhasil dihapus")),
              );

              // Refresh list
              final user = ref.read(authControllerProvider);
              if (user != null) {
                ref.read(songsControllerProvider.notifier)
                    .loadMySongs(user.id);
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ==================================================================
  // EDIT MODAL
  // ==================================================================
  void _openEditModal(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController(text: song.title);
    final artistController = TextEditingController(text: song.artist);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Lagu",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Judul Lagu",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: artistController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Artis",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  final updated = SongEntity(
                    id: song.id,
                    title: titleController.text.trim(),
                    artist: artistController.text.trim(),
                    coverUrl: song.coverUrl,
                    audioUrl: song.audioUrl,
                    uploaderId: song.uploaderId,
                  );

                  await ref.read(songRepositoryProvider).uploadSong(updated);

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Lagu berhasil diperbarui")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Simpan Perubahan"),
              ),
            ],
          ),
        );
      },
    );
  }
}
