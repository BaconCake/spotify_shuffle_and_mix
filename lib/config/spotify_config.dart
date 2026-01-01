class SpotifyConfig {
  static const String clientId = 'YOUR_CLIENT_ID_HERE';
  static const String redirectUri = 'spotify-shuffle-mix://callback';
  
  static const List<String> scopes = [
    'user-read-private',
    'user-read-email',
    'playlist-read-private',
    'playlist-read-collaborative',
    'playlist-modify-public',
    'playlist-modify-private',
  ];

  static const String authEndpoint = 'https://accounts.spotify.com/authorize';
  static const String tokenEndpoint = 'https://accounts.spotify.com/api/token';
  static const String apiBaseUrl = 'https://api.spotify.com/v1';
}