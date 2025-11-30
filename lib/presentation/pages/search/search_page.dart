import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../../widgets/song/song_card.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController query = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(songsControllerProvider);
    final notifier = ref.read(songsControllerProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C0C0C),
        elevation: 0,
        title: TextField(
          controller: query,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            notifier.searchDebounce(value);
          },
          decoration: const InputDecoration(
            hintText: "Cari lagu atau artis...",
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CATEGORY FILTER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _categoryTag(notifier, controller, "song", "Lagu"),
                const SizedBox(width: 10),
                _categoryTag(notifier, controller, "artist", "Artis"),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // RECENT SEARCH
          if (query.text.isEmpty && notifier.recentSearch.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Pencarian Terakhir",
                style: TextStyle(color: Colors.white70),
              ),
            ),

          if (query.text.isEmpty)
            Wrap(
              children: notifier.recentSearch
                  .map((kw) => Padding(
                        padding: const EdgeInsets.all(6),
                        child: GestureDetector(
                          onTap: () {
                            query.text = kw;
                            notifier.search(kw);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(kw,
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ))
                  .toList(),
            ),

          Expanded(
            child: controller.when(
              loading: () => Center(
                child: CircularProgressIndicator(),
              ),
              error: (e, _) => Center(
                child: Text("$e", style: TextStyle(color: Colors.redAccent)),
              ),
              data: (songs) {
                if (query.text.isEmpty) {
                  return Center(
                    child: Text(
                      "Ketik untuk mencari...",
                      style: TextStyle(color: Colors.white38),
                    ),
                  );
                }

                if (songs.isEmpty) {
                  return Center(
                    child: Text(
                      "Tidak ditemukan",
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: songs.length,
                  separatorBuilder: (_, __) => Divider(
                    color: Colors.white12,
                    height: 1,
                  ),
                  itemBuilder: (context, i) {
                    return SongCard(song: songs[i]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryTag(
      dynamic notifier, dynamic controller, String key, String label) {
    final isActive = notifier.searchCategory == key;

    return GestureDetector(
      onTap: () => notifier.updateCategory(key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white12,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
