import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: const BoxDecoration(
        color: Color(0xFF181818),
        border: Border(
          top: BorderSide(color: Colors.white10, width: 0.6),
        ),
      ),
      child: InkWell(
        onTap: () => context.push('/player'),
        child: Row(
          children: [
            const SizedBox(width: 16),

            // COVER
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 14),

            // TITLE + ARTIST (DUMMY)
            const Expanded(
              child: Text(
                "Sedang tidak memutar lagu",
                style: TextStyle(color: Colors.white70, fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(width: 10),

            const Icon(Icons.play_arrow, color: Colors.white, size: 28),
            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}
