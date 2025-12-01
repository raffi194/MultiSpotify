import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../widgets/playlist/playlist_header_shimmer.dart';
import '../../widgets/song_card.dart';
import '../../widgets/playlist/add_song_modal.dart';
import '../../widgets/navbar_bottom.dart';

class PlaylistDetailPage extends ConsumerStatefulWidget {
  final String playlistId;

  const PlaylistDetailPage({
    super.key,
    required this.playlistId,
  });

  @override
  ConsumerState<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends ConsumerState<PlaylistDetailPage> {
  double appBarHeight = 300;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final user = ref.read(authControllerProvider);
      if (user == null) return;

      await ref
          .read(playlistControllerProvider.notifier)
          .loadSongsInPlaylist(widget.playlistId);

      await ref
          .read(playlistControllerProvider.notifier)
          .loadPlaylists(user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final playlists = ref.watch(playlistControllerProvider);
    final playlistSongs = ref.watch(playlistControllerProviderSongs);
    final user = ref.watch(authControllerProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Tidak ada user.")),
      );
    }

    final playlist = playlists.value?.firstWhereOrNull(
      (p) => p.id == widget.playlistId,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: const NavbarBottom(index: 2),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddSong(user.id),
        backgroundColor: Colors.greenAccent.shade700,
        icon: const Icon(Icons.add),
        label: const Text("Tambah Lagu"),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _openMenu(playlist, user.id),
          ),
        ],
      ),
      body: playlist == null
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                _buildHeader(context, playlist, playlistSongs),
                _buildSongList(playlistSongs),
                const SliverToBoxAdapter(child: SizedBox(height: 150)),
              ],
            ),
    );
  }

  // ===========================================================
  // HEADER with cover (cover lagu pertama)
  // ===========================================================
  SliverAppBar _buildHeader(
    BuildContext context,
    playlist,
    playlistSongs,
  ) {
    final firstCover = playlistSongs.value?.isNotEmpty == true
        ? playlistSongs.value!.first.coverUrl
        : null;

    return SliverAppBar(
      expandedHeight: appBarHeight,
      pinned: true,
      backgroundColor: Colors.black,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // COVER IMAGE
            if (firstCover != null)
              Image.network(
                firstCover,
                fit: BoxFit.cover,
                color: Colors.black26,
                colorBlendMode: BlendMode.darken,
              )
            else
              Container(
                color: const Color(0xFF303030),
                child: const Icon(Icons.queue_music,
                    size: 90, color: Colors.white38),
              ),

            // OVERLAY GRADIENT
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Color(0xFF0D0D0D),
                    Color(0xFF0D0D0D),
                  ],
                  stops: [0.2, 0.7, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // INFO PLAYLIST
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    playlist.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    playlist.description.isEmpty
                        ? "Tanpa deskripsi"
                        : playlist.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "${playlistSongs.value?.length ?? 0} Lagu",
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // SONG LIST
  // ===========================================================
  Widget _buildSongList(playlistSongs) {
    return playlistSongs.when(
      loading: () => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: PlaylistHeaderShimmer(),
        ),
      ),
      error: (e, s) => SliverToBoxAdapter(
        child: Center(
          child: Text(
            "Error: $e",
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ),
      data: (songs) => songs.isEmpty
          ? const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "Tidak ada lagu",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            )
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final song = songs[i];
                  return Row(
                    children: [
                      Expanded(child: SongCard(song: song)),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _removeSong(song.id),
                      ),
                    ],
                  );
                },
                childCount: songs.length,
              ),
            ),
    );
  }

  // ===========================================================
  // Add Song
  // ===========================================================
  void _openAddSong(String userId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: AddSongModal(
          playlistId: widget.playlistId,
          userId: userId,
        ),
      ),
    );
  }

  // ===========================================================
  // Remove Song confirm
  // ===========================================================
  void _removeSong(String songId) async {
    final user = ref.read(authControllerProvider);
    if (user == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1B1B1B),
        title: const Text("Hapus Lagu", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Yakin ingin menghapus lagu ini dari playlist?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text("Batal", style: TextStyle(color: Colors.white70)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(playlistControllerProvider.notifier)
                  .removeSong(widget.playlistId, songId, user.id);
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // MENU EDIT / DELETE / DUPLICATE
  // ===========================================================
  void _openMenu(playlist, String userId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF181818),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 20),

              // EDIT
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text("Edit Playlist",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/playlist-edit/${playlist.id}');
                },
              ),

              // DUPLICATE
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.white),
                title: const Text("Duplikasi Playlist",
                    style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context);
                  await ref
                      .read(playlistControllerProvider.notifier)
                      .duplicate(playlist.id, userId);
                },
              ),

              // DELETE
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.redAccent),
                title: const Text("Hapus Playlist",
                    style: TextStyle(color: Colors.redAccent)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(playlist.id, userId);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(String playlistId, String userId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1B1B1B),
        title:
            const Text("Hapus Playlist", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Playlist akan dihapus permanen.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text("Batal", style: TextStyle(color: Colors.white70)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(playlistControllerProvider.notifier)
                  .delete(playlistId, userId);
              Navigator.pop(context);
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }
}
