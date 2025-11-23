class SongDto {
  final String id;
  final String title;
  final String artist;
  final String coverUrl;
  final String audioUrl;

  SongDto({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverUrl,
    required this.audioUrl,
  });

  factory SongDto.fromJson(Map<String, dynamic> json) {
    return SongDto(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      coverUrl: json['cover_url'],
      audioUrl: json['audio_url'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'artist': artist,
        'cover_url': coverUrl,
        'audio_url': audioUrl,
      };
}
