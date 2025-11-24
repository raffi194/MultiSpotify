import 'package:flutter/material.dart';
import '../../widgets/player/audio_progress_bar.dart';

class FullPlayerPage extends StatelessWidget {
  const FullPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // COVER
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 290,
                    height: 290,
                    color: Colors.grey.shade800,
                    child: const Icon(Icons.music_note, size: 100, color: Colors.white38),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            // TITLE & ARTIST
            const Text(
              "Judul Lagu",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              "Nama Artis",
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
            ),

            const SizedBox(height: 26),

            // PROGRESS BAR
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 26),
              child: AudioProgressBar(),
            ),

            const SizedBox(height: 20),

            // CONTROLS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(Icons.skip_previous_rounded, color: Colors.white, size: 40),
                  Icon(Icons.play_circle_fill, color: Colors.white, size: 70),
                  Icon(Icons.skip_next_rounded, color: Colors.white, size: 40),
                ],
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
