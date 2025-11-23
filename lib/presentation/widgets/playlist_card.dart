import 'package:flutter/material.dart';
import '../../domain/entities/playlist_entity.dart';
import 'package:go_router/go_router.dart';

class PlaylistCard extends StatelessWidget {
  final PlaylistEntity playlist;

  const PlaylistCard({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/playlist/${playlist.id}'),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade900,
        ),
        child: Row(
          children: [
            const Icon(Icons.queue_music, color: Colors.white, size: 34),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                playlist.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
