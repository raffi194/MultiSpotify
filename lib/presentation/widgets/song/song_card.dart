import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../domain/entities/song_entity.dart';

class SongCard extends ConsumerWidget {
  final SongEntity song;

  const SongCard({super.key, required this.song});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);
    // final favorites = ref.watch(favoriteControllerProvider);

    // final isFavorite =
    //     favorites.asData?.value.any((f) => f.songId == song.id) ?? false;

    final isMine = user?.id == song.uploaderId;

    return InkWell(
      onTap: () => context.push('/songs/${song.id}'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            // ============================================================
            // COVER
            // ============================================================
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                song.coverUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),

            // ============================================================
            // TITLE + ARTIST + UPLOADER
            // ============================================================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    song.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // Artist
                  Text(
                    song.artist,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // =====================================================
                  // Uploader Info (NEW)
                  // =====================================================
                  Text(
                    isMine
                        ? "Diunggah oleh Saya"
                        : "Uploader: ${_shortUid(song.uploaderId)}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // ============================================================
            // FAVORITE BUTTON
            // ============================================================
            // IconButton(
            //   onPressed: () {
            //     ref
            //         .read(favoriteControllerProvider.notifier)
            //         .toggleFavorite(song.id);
            //   },
            //   icon: Icon(
            //     isFavorite ? Icons.favorite : Icons.favorite_border,
            //     color: isFavorite ? Colors.greenAccent : Colors.white60,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // Memendekkan UID supaya cantik
  String _shortUid(String uid) {
    if (uid.length < 8) return uid;
    return uid.substring(0, 6) + "...";
  }
}
