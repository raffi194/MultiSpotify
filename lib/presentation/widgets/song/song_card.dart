import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../../../domain/entities/song_entity.dart';
import 'package:go_router/go_router.dart';

class SongCard extends ConsumerWidget {
  final SongEntity song;
  const SongCard({super.key, required this.song});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteControllerProvider);

    final isFavorite = favorites.asData?.value.any((f) => f.songId == song.id) ?? false;

    return InkWell(
      onTap: () {
        context.push('/songs/${song.id}');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            // COVER
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

            // TITLE + ARTIST
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    song.artist,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),

            // FAVORITE BUTTON
            IconButton(
              onPressed: () {
                ref.read(favoriteControllerProvider.notifier).toggleFavorite(song.id);
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.greenAccent : Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
