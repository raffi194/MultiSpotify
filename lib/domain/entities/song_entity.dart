class SongEntity {
  final String id;
  final String title;
  final String artist;
  final String coverUrl;
  final String audioUrl;
  final String uploaderId; // NEW

  SongEntity({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverUrl,
    required this.audioUrl,
    required this.uploaderId,
  });
}
