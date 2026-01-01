import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../services/spotify_service.dart';

class AuthProvider extends ChangeNotifier {
  final SpotifyService _spotifyService;

  SpotifyUser? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._spotifyService);

  SpotifyUser? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isAuth = await _spotifyService.isAuthenticated();
      if (isAuth) {
        _user = await _spotifyService.getCurrentUser();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _spotifyService.authenticate();
      if (success) {
        _user = await _spotifyService.getCurrentUser();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _spotifyService.logout();
      _user = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
