import 'dart:math';

import '../models/playlist.dart';
import '../models/track.dart';
import '../models/user.dart';
import 'spotify_service.dart';

class MockSpotifyService implements SpotifyService {
  bool _isAuthenticated = false;
  final List<Playlist> _createdPlaylists = [];
  final Random _random = Random();

  final SpotifyUser _mockUser = const SpotifyUser(
    id: 'mock_user_123',
    displayName: 'Test User',
    email: 'test@example.com',
    imageUrl: null,
    isPremium: true,
  );

  List<Track> _generateMockTracks() {
    final mockTracks = [
      ('Blinding Lights', 'The Weeknd', 'After Hours', 128.0),
      ('Levitating', 'Dua Lipa', 'Future Nostalgia', 103.0),
      ('Save Your Tears', 'The Weeknd', 'After Hours', 118.0),
      ('Watermelon Sugar', 'Harry Styles', 'Fine Line', 95.0),
      ('Peaches', 'Justin Bieber', 'Justice', 90.0),
      ('Kiss Me More', 'Doja Cat', 'Planet Her', 111.0),
      ('Good 4 U', 'Olivia Rodrigo', 'SOUR', 166.0),
      ('Montero', 'Lil Nas X', 'Montero', 88.0),
      ('Stay', 'Kid Laroi & Justin Bieber', 'F*ck Love 3', 170.0),
      ('Industry Baby', 'Lil Nas X', 'Montero', 150.0),
      ('Heat Waves', 'Glass Animals', 'Dreamland', 81.0),
      ('Shivers', 'Ed Sheeran', '=', 141.0),
      ('Easy On Me', 'Adele', '30', 72.0),
      ('Ghost', 'Justin Bieber', 'Justice', 77.0),
      ('Happier Than Ever', 'Billie Eilish', 'Happier Than Ever', 60.0),
    ];

    return mockTracks.asMap().entries.map((entry) {
      final i = entry.key;
      final t = entry.value;
      return Track(
        id: 'track_$i',
        name: t.$1,
        artistName: t.$2,
        albumName: t.$3,
        albumImageUrl: null,
        durationMs: 180000 + _random.nextInt(120000),
        bpm: t.$4,
        uri: 'spotify:track:mock_$i',
      );
    }).toList();
  }

  @override
  Future<bool> authenticate() async {
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    return true;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _isAuthenticated = false;
    _createdPlaylists.clear();
  }

  @override
  Future<bool> isAuthenticated() async {
    return _isAuthenticated;
  }

  @override
  Future<SpotifyUser?> getCurrentUser() async {
    if (!_isAuthenticated) return null;
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockUser;
  }

  @override
  Future<Playlist?> getPlaylist(String playlistId) async {
    if (!_isAuthenticated) return null;
    await Future.delayed(const Duration(milliseconds: 500));

    final createdPlaylist = _createdPlaylists
        .where((p) => p.id == playlistId)
        .firstOrNull;
    if (createdPlaylist != null) {
      return createdPlaylist;
    }

    final tracks = _generateMockTracks();
    return Playlist(
      id: playlistId,
      name: 'My Awesome Playlist',
      description: 'A mock playlist for testing',
      imageUrl: null,
      ownerId: _mockUser.id,
      ownerName: _mockUser.displayName,
      trackCount: tracks.length,
      tracks: tracks,
    );
  }

  @override
  Future<List<Track>> getPlaylistTracks(String playlistId) async {
    final playlist = await getPlaylist(playlistId);
    return playlist?.tracks ?? [];
  }

  @override
  Future<Map<String, double>> getTracksBpm(List<String> trackIds) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {for (var id in trackIds) id: 80.0 + _random.nextDouble() * 100};
  }

  @override
  Future<Playlist?> createPlaylist(
    String name, {
    String? description,
    bool public = false,
  }) async {
    if (!_isAuthenticated) return null;
    await Future.delayed(const Duration(milliseconds: 500));

    final playlist = Playlist(
      id: 'created_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
      imageUrl: null,
      ownerId: _mockUser.id,
      ownerName: _mockUser.displayName,
      trackCount: 0,
      tracks: [],
      isPublic: public,
    );

    _createdPlaylists.add(playlist);
    return playlist;
  }

  @override
  Future<bool> addTracksToPlaylist(
    String playlistId,
    List<String> trackUris,
  ) async {
    if (!_isAuthenticated) return false;
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> reorderPlaylistTracks(
    String playlistId,
    int rangeStart,
    int insertBefore, {
    int rangeLength = 1,
  }) async {
    if (!_isAuthenticated) return false;
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }
}
