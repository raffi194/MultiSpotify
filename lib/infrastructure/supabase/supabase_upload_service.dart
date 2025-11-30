import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseUploadService {
  final SupabaseClient client = Supabase.instance.client;

  Future<String> uploadImage(File file) async {
    final fileName =
        "cover_${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}";

    final res = await client.storage
        .from('covers')
        .upload(fileName, file, fileOptions: const FileOptions(upsert: false));

    return client.storage.from('covers').getPublicUrl(fileName);
  }

  Future<String> uploadAudio(File file) async {
    final fileName =
        "audio_${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}";

    final res = await client.storage
        .from('audios')
        .upload(fileName, file, fileOptions: const FileOptions(upsert: false));

    return client.storage.from('audios').getPublicUrl(fileName);
  }
}
