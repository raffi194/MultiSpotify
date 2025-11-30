class FavoriteDto {
  final String id;
  final String userId;
  final String songId;

  FavoriteDto({
    required this.id,
    required this.userId,
    required this.songId,
  });

  factory FavoriteDto.fromJson(Map<String, dynamic> json) {
    return FavoriteDto(
      id: json['id'],
      userId: json['user_id'],
      songId: json['song_id'],
    );
  }
}
