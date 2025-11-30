import 'package:flutter/material.dart';
import '../../domain/entities/playlist_entity.dart';

class AddToPlaylistModal extends StatelessWidget {
  final List<PlaylistEntity> playlists;
  final Function(String playlistId) onSelect;

  const AddToPlaylistModal({
    super.key,
    required this.playlists,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Tambahkan ke Playlist"),
      children: playlists
          .map(
            (p) => SimpleDialogOption(
              onPressed: () => onSelect(p.id),
              child: Text(p.name),
            ),
          )
          .toList(),
    );
  }
}
