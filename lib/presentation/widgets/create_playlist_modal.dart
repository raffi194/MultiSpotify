import 'package:flutter/material.dart';

class CreatePlaylistModal extends StatefulWidget {
  final Function(String name, String desc) onSubmit;

  const CreatePlaylistModal({super.key, required this.onSubmit});

  @override
  State<CreatePlaylistModal> createState() => _CreatePlaylistModalState();
}

class _CreatePlaylistModalState extends State<CreatePlaylistModal> {
  final name = TextEditingController();
  final desc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade900,
      title: const Text(
        "Buat Playlist Baru",
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: name,
            decoration: const InputDecoration(hintText: 'Nama Playlist'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: desc,
            decoration: const InputDecoration(hintText: 'Deskripsi'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSubmit(name.text, desc.text);
            Navigator.pop(context);
          },
          child: const Text("Buat"),
        ),
      ],
    );
  }
}
