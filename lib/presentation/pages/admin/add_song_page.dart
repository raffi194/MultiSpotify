import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/di/providers.dart';
import '../../../domain/entities/song_entity.dart';
import '../../controllers/songs_controller.dart';
import '../../../infrastructure/supabase/supabase_upload_service.dart';
import '../../widgets/navbar_bottom.dart';

class AddSongPage extends ConsumerStatefulWidget {
  const AddSongPage({super.key});

  @override
  ConsumerState<AddSongPage> createState() => _AddSongPageState();
}

class _AddSongPageState extends ConsumerState<AddSongPage> {
  final title = TextEditingController();
  final artist = TextEditingController();

  File? cover;
  File? audio;

  bool loading = false;

  Future pickCover() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      cover = File(result.files.single.path!);
      setState(() {});
    }
  }

  Future pickAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      audio = File(result.files.single.path!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);

    if (user?.email != "admin@gmail.com") {
      return const Scaffold(
        body: Center(
          child: Text(
            "Anda tidak memiliki akses admin.",
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Lagu")),
      bottomNavigationBar: const NavbarBottom(index: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(hintText: "Judul Lagu"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: artist,
              decoration: const InputDecoration(hintText: "Artist"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: pickCover,
              child: const Text("Pilih Cover"),
            ),
            if (cover != null) Image.file(cover!, height: 150),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: pickAudio,
              child: const Text("Pilih File Audio"),
            ),
            if (audio != null)
              Text(
                audio!.path.split('/').last,
                style: const TextStyle(color: Colors.white70),
              ),

            const SizedBox(height: 24),

            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (cover == null || audio == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Cover atau audio belum dipilih"),
                          ),
                        );
                        return;
                      }

                      setState(() => loading = true);

                      try {
                        final uploader = SupabaseUploadService();

                        final coverUrl = await uploader.uploadImage(cover!);
                        final audioUrl = await uploader.uploadAudio(audio!);

                        final newSong = SongEntity(
                          id: "",
                          title: title.text.trim(),
                          artist: artist.text.trim(),
                          coverUrl: coverUrl,
                          audioUrl: audioUrl,
                        );

                        await ref
                            .read(songsControllerProvider.notifier)
                            .uploadSong(newSong);

                        await ref
                            .read(songsControllerProvider.notifier)
                            .load();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Lagu berhasil ditambahkan!"),  
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $e")),
                        );
                      }

                      setState(() => loading = false);
                    },
                    child: const Text("Upload Lagu"),
                  ),
          ],
        ),
      ),
    );
  }
}
