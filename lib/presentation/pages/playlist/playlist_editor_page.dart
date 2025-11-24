import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';

class PlaylistEditorPage extends ConsumerStatefulWidget {
  const PlaylistEditorPage({super.key});

  @override
  ConsumerState<PlaylistEditorPage> createState() =>
      _PlaylistEditorPageState();
}

class _PlaylistEditorPageState extends ConsumerState<PlaylistEditorPage> {
  final name = TextEditingController();
  final description = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Buat Playlist")),
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
                    onPressed: () async {
                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Anda belum login."),
                          ),
                        );
                        return;
                      }

                      if (name.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Nama belum diisi")),
                        );
                        return;
                      }

                      setState(() => loading = true);

                      await ref
                          .read(playlistControllerProvider.notifier)
                          .create(
                            name.text.trim(),
                            description.text.trim(),
                            user.id, // aman karena sudah diperiksa
                          );

                      setState(() => loading = false);

                      Navigator.pop(context);
                    },
                    child: const Text("Simpan Playlist"),
                  ),
          ],
        ),
      ),
    );
  }
}
