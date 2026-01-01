import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.music_note_rounded,
                size: 80,
                color: AppTheme.spotifyGreen,
              ),
              const SizedBox(height: 24),
              const Text(
                'Spotify Shuffle & Mix',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.spotifyWhite,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Reorder your playlists by BPM and create perfect mixes',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.spotifyLightGray,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  if (auth.isLoading) {
                    return const CircularProgressIndicator(
                      color: AppTheme.spotifyGreen,
                    );
                  }

                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _handleLogin(context, auth),
                          icon: const Icon(Icons.login),
                          label: const Text('Connect with Spotify'),
                        ),
                      ),
                      if (auth.error != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          auth.error!,
                          style: const TextStyle(color: Colors.redAccent),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Using mock data until Spotify API is connected',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.spotifyLightGray,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context, AuthProvider auth) async {
    final success = await auth.login();
    if (success && context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }
}