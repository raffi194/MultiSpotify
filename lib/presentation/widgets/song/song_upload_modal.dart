import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../core/di/providers.dart';
import '../../../domain/entities/song_entity.dart';

class SongUploadModal extends ConsumerStatefulWidget {
  const SongUploadModal({super.key});

  @override
  ConsumerState<SongUploadModal> createState() => _SongUploadModalState();
}

class _SongUploadModalState extends ConsumerState<SongUploadModal>
    with SingleTickerProviderStateMixin {
  final title = TextEditingController();
  final artist = TextEditingController();
  final coverUrlController = TextEditingController();
  final audioUrlController = TextEditingController();

  bool uploading = false;

  late AnimationController _anim;
  late Animation<double> _slide;

  @override
  void initState() {
    super.initState();

    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slide = Tween<double>(begin: 160, end: 0).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic),
    );

    _anim.forward();
  }

  // =============================================================
  // PREVIEW AUDIO (HEAD Request)
  // =============================================================
  Future<String?> getAudioSize(String url) async {
    try {
      final res = await http.head(Uri.parse(url));
      if (res.headers.containsKey("content-length")) {
        final bytes = int.tryParse(res.headers["content-length"]!) ?? 0;
        return "${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB";
      }
    } catch (_) {}
    return null;
  }

  void showAudioPreview() async {
    final url = audioUrlController.text.trim();
    if (url.isEmpty) return;

    final size = await getAudioSize(url);

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.music_note, size: 60, color: Colors.white70),
                Text(
                  url.split('/').last,
                  style: const TextStyle(color: Colors.white),
                ),
                if (size != null)
                  Text(
                    size,
                    style: const TextStyle(color: Colors.white54),
                  ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tutup"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // =============================================================
  // CONFIRMATION
  // =============================================================
  Future<bool> confirmUpload() async {
    return await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Konfirmasi Upload"),
          content: const Text("Apakah data sudah benar?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Upload"),
            ),
          ],
        );
      },
    );
  }

  // =============================================================
  // UPLOAD
  // =============================================================
  Future upload() async {
    if (title.text.trim().isEmpty) return notify("Judul wajib diisi");
    if (artist.text.trim().isEmpty) return notify("Artist wajib diisi");
    if (coverUrlController.text.trim().isEmpty) {
      return notify("Cover URL wajib diisi");
    }
    if (audioUrlController.text.trim().isEmpty) {
      return notify("Audio URL wajib diisi");
    }

    final ok = await confirmUpload();
    if (!ok) return;

    final user = ref.read(authControllerProvider);
    if (user == null) return;

    setState(() => uploading = true);

    try {
      final song = SongEntity(
        id: "",
        title: title.text.trim(),
        artist: artist.text.trim(),
        coverUrl: coverUrlController.text.trim(),
        audioUrl: audioUrlController.text.trim(),
        uploaderId: user.id,
      );

      await ref.read(songsControllerProvider.notifier).uploadSong(song);

      notify("Lagu berhasil diupload!");
      Navigator.pop(context);
    } catch (e) {
      notify("Gagal upload: $e");
    }

    setState(() => uploading = false);
  }

  void notify(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // =============================================================
  // UI
  // =============================================================
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.black45,
        body: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(),
            ),

            // =============================================================
            // MODAL SLIDE
            // =============================================================
            AnimatedBuilder(
              animation: _anim,
              builder: (_, child) => Transform.translate(
                offset: Offset(0, _slide.value),
                child: child,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: size.width,
                  height: size.height * 0.88,
                  padding: const EdgeInsets.all(22),
                  decoration: const BoxDecoration(
                    color: Color(0xFF131313),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(26)),
                  ),

                  // =============================================================
                  // SCROLLABLE BODY (ANTI OVERFLOW)
                  // =============================================================
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        const Text(
                          "Upload Lagu Baru",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 22),

                        _inputField(controller: title, label: "Judul Lagu"),
                        const SizedBox(height: 14),

                        _inputField(controller: artist, label: "Artist"),
                        const SizedBox(height: 20),

                        // =============================================================
                        // COVER URL
                        // =============================================================
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: _box(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Cover URL (Cloudinary)",
                                  style: TextStyle(color: Colors.white70)),
                              const SizedBox(height: 8),

                              TextField(
                                controller: coverUrlController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText:
                                      "https://res.cloudinary.com/.../cover.jpg",
                                  hintStyle:
                                      const TextStyle(color: Colors.white38),
                                  filled: true,
                                  fillColor: Colors.white10,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onChanged: (_) => setState(() {}),
                              ),

                              const SizedBox(height: 12),

                              if (coverUrlController.text.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    coverUrlController.text.trim(),
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Text("URL tidak valid",
                                            style: TextStyle(color: Colors.red)),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        // =============================================================
                        // AUDIO URL
                        // =============================================================
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: _box(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Audio URL (Cloudinary MP3)",
                                  style: TextStyle(color: Colors.white70)),
                              const SizedBox(height: 8),

                              TextField(
                                controller: audioUrlController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText:
                                      "https://res.cloudinary.com/.../audio.mp3",
                                  hintStyle:
                                      const TextStyle(color: Colors.white38),
                                  filled: true,
                                  fillColor: Colors.white10,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onChanged: (_) => setState(() {}),
                              ),

                              const SizedBox(height: 12),

                              if (audioUrlController.text.isNotEmpty)
                                GestureDetector(
                                  onTap: showAudioPreview,
                                  child: Row(
                                    children: const [
                                      Icon(Icons.visibility,
                                          color: Colors.greenAccent),
                                      SizedBox(width: 8),
                                      Text("Preview Audio",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // =============================================================
                        // BUTTON UPLOAD
                        // =============================================================
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: uploading ? null : upload,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent.shade700,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: uploading
                                ? const CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2)
                                : const Text(
                                    "Upload Lagu",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // =============================================================
  // COMPONENTS
  // =============================================================
  Widget _inputField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  BoxDecoration _box() {
    return BoxDecoration(
      color: Colors.white10,
      borderRadius: BorderRadius.circular(12),
    );
  }
}
