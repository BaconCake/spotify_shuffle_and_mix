class SpotifyUser {
  final String id;
  final String displayName;
  final String? email;
  final String? imageUrl;
  final bool isPremium;

  const SpotifyUser({
    required this.id,
    required this.displayName,
    this.email,
    this.imageUrl,
    this.isPremium = false,
  });

  factory SpotifyUser.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List<dynamic>? ?? [];

    return SpotifyUser(
      id: json['id'] as String? ?? '',
      displayName: json['display_name'] as String? ?? 'User',
      email: json['email'] as String?,
      imageUrl: images.isNotEmpty ? images.first['url'] as String? : null,
      isPremium: json['product'] == 'premium',
    );
  }
}
