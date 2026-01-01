class Track {
  final String id;
  final String name;
  final String artistName;
  final String albumName;
  final String? albumImageUrl;
  final int durationMs;
  final double? bpm;
  final String uri;

  const Track({
    required this.id,
    required this.name,
    required this.artistName,
    required this.albumName,
    this.albumImageUrl,
    required this.durationMs,
    this.bpm,
    required this.uri,
  });

  String get durationFormatted {
    final minutes = (durationMs / 60000).floor();
    final seconds = ((durationMs % 60000) / 1000).floor();
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Track copyWith({double? bpm}) {
    return Track(
      id: id,
      name: name,
      artistName: artistName,
      albumName: albumName,
      albumImageUrl: albumImageUrl,
      durationMs: durationMs,
      bpm: bpm ?? this.bpm,
      uri: uri,
    );
  }

  factory Track.fromJson(Map<String, dynamic> json) {
    final track = json['track'] as Map<String, dynamic>? ?? json;
    final artists = track['artists'] as List<dynamic>? ?? [];
    final album = track['album'] as Map<String, dynamic>? ?? {};
    final images = album['images'] as List<dynamic>? ?? [];

    return Track(
      id: track['id'] as String? ?? '',
      name: track['name'] as String? ?? 'Unknown',
      artistName: artists.isNotEmpty
          ? (artists.first['name'] as String? ?? 'Unknown Artist')
          : 'Unknown Artist',
      albumName: album['name'] as String? ?? 'Unknown Album',
      albumImageUrl: images.isNotEmpty ? images.first['url'] as String? : null,
      durationMs: track['duration_ms'] as int? ?? 0,
      uri: track['uri'] as String? ?? '',
    );
  }
}
