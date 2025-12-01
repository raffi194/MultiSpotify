import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../widgets/song/song_card.dart';

class MySongsPage extends ConsumerStatefulWidget {
  const MySongsPage({super.key});

  @override
  ConsumerState<MySongsPage> createState() => _MySongsPageState();
}

class _MySongsPageState extends ConsumerState<MySongsPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final user = ref.read(authControllerProvider);
      if (user != null) {
        await ref.read(songsControllerProvider.notifier)
            .loadMySongs(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);
    final songs = ref.watch(songsControllerProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Silakan login terlebih dahulu",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
      appBar: AppBar(
        title: const Text("Lagu Saya Upload"),
        backgroundColor: Colors.black,
      ),
      body: songs.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.greenAccent),
        ),

        error: (e, s) => Center(
          child: Text(
            "Gagal memuat lagu: $e",
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),

        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Text(
                "Belum ada lagu yang kamu upload.",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(top: 10),
            itemCount: list.length,
            separatorBuilder: (_, __) =>
                const Divider(color: Colors.white12, height: 1),
            itemBuilder: (_, i) => SongCard(song: list[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/song-upload'),
        backgroundColor: Colors.greenAccent.shade700,
        icon: const Icon(Icons.upload),
        label: const Text("Upload Lagi"),
      ),
    );
  }
}
