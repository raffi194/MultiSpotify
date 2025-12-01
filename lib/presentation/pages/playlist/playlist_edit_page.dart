import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../../../core/di/providers.dart';

class PlaylistEditPage extends ConsumerStatefulWidget {
  final String playlistId;

  const PlaylistEditPage({
    super.key,
    required this.playlistId,
  });

  @override
  ConsumerState<PlaylistEditPage> createState() => _PlaylistEditPageState();
}

class _PlaylistEditPageState extends ConsumerState<PlaylistEditPage> {
  final name = TextEditingController();
  final description = TextEditingController();

  bool loading = false;
  bool initialized = false;

  String? originalName;
  String? originalDescription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {
      final playlists = ref.read(playlistControllerProvider).value;

      final target = playlists?.firstWhereOrNull(
        (p) => p.id == widget.playlistId,
      );

      if (target != null) {
        originalName = target.name;
        originalDescription = target.description ?? "";

        name.text = originalName!;
        description.text = originalDescription!;
      }

      initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Playlist"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(hintText: "Nama Playlist"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: description,
              decoration: const InputDecoration(hintText: "Deskripsi Playlist"),
            ),
            const SizedBox(height: 24),

            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => _onSave(user),
                    child: const Text("Simpan Perubahan"),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSave(user) async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Anda belum login.")),
      );
      return;
    }

    final newName = name.text.trim();
    final newDesc = description.text.trim();

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama playlist harus diisi")),
      );
      return;
    }

    final changedName = newName != originalName;
    final changedDesc = newDesc != originalDescription;

    if (!changedName && !changedDesc) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada perubahan.")),
      );
      return;
    }

    setState(() => loading = true);

    await ref.read(playlistControllerProvider.notifier).updatePlaylist(
          widget.playlistId,
          newName,
          newDesc,
          user.id,
        );

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Playlist berhasil diperbarui")),
    );

    Navigator.pop(context);
  }
}
