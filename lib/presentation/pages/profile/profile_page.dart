import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';

// Widgets
import '../../widgets/profile/profile_edit_modal.dart';
import '../../widgets/profile/playlist_preview_list.dart';
import '../../widgets/profile/playlist_preview_shimmer.dart';
import '../../widgets/song/song_upload_modal.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  double avatarOffset = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final user = ref.read(authControllerProvider);
      if (user != null) {
        ref
            .read(playlistControllerProvider.notifier)
            .loadPlaylistsWithoutSongs(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final playlists = ref.watch(playlistControllerProvider);
    final user = ref.watch(authControllerProvider);

    final initial =
        (user?.email.isNotEmpty ?? false) ? user!.email[0].toUpperCase() : "?";

    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (scroll) {
        setState(() {
          avatarOffset = (scroll.metrics.pixels * 0.25).clamp(0, 40);
        });
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0C0C0C),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              backgroundColor: Colors.black,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF202020), Color(0xFF0C0C0C)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, avatarOffset),
                      child: Hero(
                        tag: "profile-avatar",
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white24,
                          child: Text(
                            initial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 46,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // CONTENT BODY
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.email ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // =========================================================
                    // BUTTON: Kembali ke Home
                    // =========================================================
                    ElevatedButton(
                      onPressed: () => context.go('/'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white10,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.white24),
                        ),
                      ),
                      child: const Text(
                        "Kembali ke Home",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // EDIT PROFILE
                    ElevatedButton(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const ProfileEditModal(),
                      ),
                      child: const Text("Edit Profil"),
                    ),

                    const SizedBox(height: 30),

                    // UPLOAD LAGU
                    ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const SongUploadModal(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Upload Lagu",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () => context.push('/my-songs'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: const Text("Lihat Lagu Saya"),
                    ),

                    const SizedBox(height: 30),

                    // PLAYLIST HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Playlist Kamu",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/playlists'),
                          child: const Text(
                            "Lihat Semua",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    playlists.maybeWhen(
                      data: (list) {
                        return Text(
                          "${list.length} Playlist",
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        );
                      },
                      orElse: () => const SizedBox(),
                    ),

                    const SizedBox(height: 20),

                    playlists.when(
                      data: (list) => list.isEmpty
                          ? const Text(
                              "Belum ada playlist. Buat playlist pertama kamu!",
                              style: TextStyle(color: Colors.white54),
                            )
                          : PlaylistPreviewList(playlists: list),
                      loading: () => const PlaylistPreviewShimmer(),
                      error: (e, s) => Text(
                        "Error: $e",
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),

                    const SizedBox(height: 50),

                    // LOGOUT
                    ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(authControllerProvider.notifier)
                            .logout();
                        context.go('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Logout",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
