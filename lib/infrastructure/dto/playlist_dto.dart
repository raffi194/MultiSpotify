  class PlaylistDto {
    final String id;
    final String name;
    final String description;
    final String userId;

    PlaylistDto({
      required this.id,
      required this.name,
      required this.description,
      required this.userId,
    });

    factory PlaylistDto.fromJson(Map<String, dynamic> json) {
      return PlaylistDto(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        userId: json['user_id'],
      );
    }
  }
