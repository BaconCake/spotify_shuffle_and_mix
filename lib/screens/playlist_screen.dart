import 'package:flutter/material.dart';

import '../models/playlist.dart';
import '../models/track.dart';
import '../services/mock_spotify_service.dart';
import '../services/spotify_service.dart';
import '../theme/app_theme.dart';

class PlaylistScreen extends StatefulWidget {
  final String playlistId;

  const PlaylistScreen({super.key, required this.playlistId});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final SpotifyService _spotifyService = MockSpotifyService();

  Playlist? _playlist;
  List<Track> _tracks = [];
  bool _isLoading = true;
  String? _error;
  SortMode _sortMode = SortMode.original;

  @override
  void initState() {
    super.initState();
    _loadPlaylist();
  }

  Future<void> _loadPlaylist() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _spotifyService.authenticate();
      final playlist = await _spotifyService.getPlaylist(widget.playlistId);
      if (playlist != null) {
        setState(() {
          _playlist = playlist;
          _tracks = List.from(playlist.tracks);
        });
      } else {
        setState(() => _error = 'Playlist not found');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _sortTracks(SortMode mode) {
    setState(() {
      _sortMode = mode;
      switch (mode) {
        case SortMode.original:
          _tracks = List.from(_playlist?.tracks ?? []);
        case SortMode.bpmAscending:
          _tracks.sort((a, b) => (a.bpm ?? 0).compareTo(b.bpm ?? 0));
        case SortMode.bpmDescending:
          _tracks.sort((a, b) => (b.bpm ?? 0).compareTo(a.bpm ?? 0));
        case SortMode.nameAscending:
          _tracks.sort((a, b) => a.name.compareTo(b.name));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_playlist?.name ?? 'Loading...'),
        actions: [
          PopupMenuButton<SortMode>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort tracks',
            onSelected: _sortTracks,
            itemBuilder: (context) => [
              _buildSortMenuItem(SortMode.original, 'Original Order', Icons.format_list_numbered),
              _buildSortMenuItem(SortMode.bpmAscending, 'BPM (Low to High)', Icons.arrow_upward),
              _buildSortMenuItem(SortMode.bpmDescending, 'BPM (High to Low)', Icons.arrow_downward),
              _buildSortMenuItem(SortMode.nameAscending, 'Name (A-Z)', Icons.sort_by_alpha),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copy to new playlist',
            onPressed: _playlist != null ? _showCopyDialog : null,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  PopupMenuItem<SortMode> _buildSortMenuItem(SortMode mode, String text, IconData icon) {
    return PopupMenuItem(
      value: mode,
      child: Row(
        children: [
          Icon(icon, size: 20, color: _sortMode == mode ? AppTheme.spotifyGreen : null),
          const SizedBox(width: 12),
          Text(text),
          if (_sortMode == mode) ...[
            const Spacer(),
            const Icon(Icons.check, size: 20, color: AppTheme.spotifyGreen),
          ],
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.spotifyGreen),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.redAccent)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPlaylist,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        _buildPlaylistHeader(),
        Expanded(child: _buildTrackList()),
      ],
    );
  }

  Widget _buildPlaylistHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.spotifyDarkGray,
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.spotifyBlack,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.queue_music, size: 40, color: AppTheme.spotifyLightGray),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _playlist?.name ?? '',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_tracks.length} tracks • ${_playlist?.ownerName ?? ''}',
                  style: const TextStyle(color: AppTheme.spotifyLightGray),
                ),
                if (_playlist?.description != null && _playlist!.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _playlist!.description!,
                    style: const TextStyle(color: AppTheme.spotifyLightGray, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackList() {
    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _tracks.length,
      onReorder: _onReorder,
      itemBuilder: (context, index) {
        final track = _tracks[index];
        return _buildTrackTile(track, index);
      },
    );
  }

  Widget _buildTrackTile(Track track, int index) {
    return Card(
      key: ValueKey(track.id),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.drag_handle, color: AppTheme.spotifyLightGray),
            ),
            const SizedBox(width: 12),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.spotifyBlack,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.music_note, color: AppTheme.spotifyLightGray),
            ),
          ],
        ),
        title: Text(
          track.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          track.artistName,
          style: const TextStyle(color: AppTheme.spotifyLightGray),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (track.bpm != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.spotifyGreen.withAlpha(51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${track.bpm!.round()} BPM',
                  style: const TextStyle(
                    color: AppTheme.spotifyGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 12),
            Text(
              track.durationFormatted,
              style: const TextStyle(color: AppTheme.spotifyLightGray),
            ),
          ],
        ),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final track = _tracks.removeAt(oldIndex);
      _tracks.insert(newIndex, track);
      _sortMode = SortMode.original;
    });
  }

  void _showCopyDialog() {
    final nameController = TextEditingController(text: '${_playlist!.name} (Sorted)');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.spotifyDarkGray,
        title: const Text('Create New Playlist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Playlist name',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            const Text(
              'This will create a new playlist with the current track order.',
              style: TextStyle(color: AppTheme.spotifyLightGray, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _createPlaylist(nameController.text);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _createPlaylist(String name) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Creating playlist...'),
        duration: Duration(seconds: 1),
      ),
    );

    try {
      final newPlaylist = await _spotifyService.createPlaylist(name);
      if (newPlaylist != null) {
        final trackUris = _tracks.map((t) => t.uri).toList();
        await _spotifyService.addTracksToPlaylist(newPlaylist.id, trackUris);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Created playlist: ${newPlaylist.name}'),
              backgroundColor: AppTheme.spotifyGreen,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}

enum SortMode {
  original,
  bpmAscending,
  bpmDescending,
  nameAscending,
}