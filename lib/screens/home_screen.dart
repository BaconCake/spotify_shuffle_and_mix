import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'playlist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _playlistIdController = TextEditingController();

  @override
  void dispose() {
    _playlistIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spotify Shuffle & Mix'),
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    user.displayName,
                    style: const TextStyle(color: AppTheme.spotifyLightGray),
                  ),
                  const SizedBox(width: 8),
                  if (user.isPremium)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.spotifyGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'PREMIUM',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.spotifyBlack,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.queue_music,
                size: 64,
                color: AppTheme.spotifyGreen,
              ),
              const SizedBox(height: 24),
              const Text(
                'Load a Playlist',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter a Spotify playlist ID or URL to get started',
                style: TextStyle(color: AppTheme.spotifyLightGray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _playlistIdController,
                decoration: const InputDecoration(
                  hintText: 'Playlist ID or URL',
                  prefixIcon: Icon(Icons.link),
                ),
                onSubmitted: (_) => _loadPlaylist(),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadPlaylist,
                icon: const Icon(Icons.search),
                label: const Text('Load Playlist'),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: _loadMockPlaylist,
                icon: const Icon(Icons.science),
                label: const Text('Load Demo Playlist'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadPlaylist() {
    final input = _playlistIdController.text.trim();
    if (input.isEmpty) return;

    final playlistId = _extractPlaylistId(input);
    _navigateToPlaylist(playlistId);
  }

  void _loadMockPlaylist() {
    _navigateToPlaylist('demo_playlist');
  }

  String _extractPlaylistId(String input) {
    final urlPattern = RegExp(r'playlist[/:]([a-zA-Z0-9]+)');
    final match = urlPattern.firstMatch(input);
    return match?.group(1) ?? input;
  }

  void _navigateToPlaylist(String playlistId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlaylistScreen(playlistId: playlistId),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    await context.read<AuthProvider>().logout();
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }
}