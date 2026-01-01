import '../models/playlist.dart';
import '../models/track.dart';
import '../models/user.dart';

abstract class SpotifyService {
  Future<bool> authenticate();
  Future<void> logout();
  Future<bool> isAuthenticated();
  Future<SpotifyUser?> getCurrentUser();
  Future<Playlist?> getPlaylist(String playlistId);
  Future<List<Track>> getPlaylistTracks(String playlistId);
  Future<Map<String, double>> getTracksBpm(List<String> trackIds);
  Future<Playlist?> createPlaylist(
    String name, {
    String? description,
    bool public = false,
  });
  Future<bool> addTracksToPlaylist(String playlistId, List<String> trackUris);
  Future<bool> reorderPlaylistTracks(
    String playlistId,
    int rangeStart,
    int insertBefore, {
    int rangeLength = 1,
  });
}
