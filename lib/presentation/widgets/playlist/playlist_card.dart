import 'package:flutter/material.dart';
import '../../../domain/entities/playlist_entity.dart';
import 'package:go_router/go_router.dart';

class PlaylistCard extends StatelessWidget {
  final PlaylistEntity playlist;
  const PlaylistCard({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/playlist/${playlist.id}'),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PLAYLIST COVER (DEFAULT)
            Container(
              height: 85,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.queue_music, size: 42, color: Colors.white54),
            ),
            const SizedBox(height: 10),

            // NAME (bukan title)
            Text(
              playlist.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 3),

            // DESCRIPTION (langsung string, tidak nullable)
            Text(
              playlist.description.isEmpty ? "Tanpa deskripsi" : playlist.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
