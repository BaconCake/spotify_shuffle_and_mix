import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/auth_provider.dart';
import 'services/mock_spotify_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final spotifyService = MockSpotifyService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(spotifyService),
        ),
      ],
      child: const SpotifyShuffleApp(),
    ),
  );
}