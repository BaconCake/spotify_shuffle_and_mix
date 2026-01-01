import 'track.dart';

class Playlist {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String ownerId;
  final String ownerName;
  final int trackCount;
  final List<Track> tracks;
  final bool isPublic;

  const Playlist({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.ownerId,
    required this.ownerName,
    required this.trackCount,
    this.tracks = const [],
    this.isPublic = true,
  });

  Playlist copyWith({List<Track>? tracks}) {
    return Playlist(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      ownerId: ownerId,
      ownerName: ownerName,
      trackCount: tracks?.length ?? trackCount,
      tracks: tracks ?? this.tracks,
      isPublic: isPublic,
    );
  }

  factory Playlist.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List<dynamic>? ?? [];
    final owner = json['owner'] as Map<String, dynamic>? ?? {};
    final tracksData = json['tracks'] as Map<String, dynamic>? ?? {};

    return Playlist(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Playlist',
      description: json['description'] as String?,
      imageUrl: images.isNotEmpty ? images.first['url'] as String? : null,
      ownerId: owner['id'] as String? ?? '',
      ownerName: owner['display_name'] as String? ?? 'Unknown',
      trackCount: tracksData['total'] as int? ?? 0,
      isPublic: json['public'] as bool? ?? true,
    );
  }
}
