import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';

class PlaylistCreatePage extends ConsumerStatefulWidget {
  const PlaylistCreatePage({super.key});

  @override
  ConsumerState<PlaylistCreatePage> createState() => _PlaylistCreatePageState();
}

class _PlaylistCreatePageState extends ConsumerState<PlaylistCreatePage> {
  final name = TextEditingController();
  final description = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Playlist"),
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
                    onPressed: () => _onCreate(user),
                    child: const Text("Simpan Playlist"),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _onCreate(user) async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Anda belum login.")),
      );
      return;
    }

    if (name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama playlist harus diisi")),
      );
      return;
    }

    setState(() => loading = true);

    await ref.read(playlistControllerProvider.notifier).create(
          name.text.trim(),
          description.text.trim(),
          user.id,
        );

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Playlist berhasil dibuat")),
    );

    Navigator.pop(context);
  }
}
