class SongDto {
  final String id;
  final String title;
  final String artist;
  final String coverUrl;
  final String audioUrl;
  final String uploaderId;

  SongDto({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverUrl,
    required this.audioUrl,
    required this.uploaderId,
  });

  factory SongDto.fromJson(Map<String, dynamic> json) {
    return SongDto(
      id: json["id"].toString(),
      title: json["title"] ?? "",
      artist: json["artist"] ?? "",
      coverUrl: json["cover_url"] ?? "",
      audioUrl: json["audio_url"] ?? "",
      uploaderId: json["uploader_id"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "artist": artist,
      "cover_url": coverUrl,
      "audio_url": audioUrl,
      "uploader_id": uploaderId,
    };
  }
}
