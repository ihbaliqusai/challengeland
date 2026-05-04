import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../core/constants/app_config.dart';
import '../core/constants/app_strings.dart';
import '../models/game_session.dart';
import '../models/user_profile.dart';
import '../services/matchmaking_service.dart';

class MatchmakingProvider extends ChangeNotifier {
  MatchmakingProvider({MatchmakingService? matchmakingService})
    : _matchmakingService = matchmakingService ?? MatchmakingService();

  final MatchmakingService _matchmakingService;

  bool isSearching = false;
  String? error;
  GameSession? session;

  Future<void> startQuickMatch(UserProfile user) async {
    isSearching = true;
    error = null;
    notifyListeners();
    try {
      final connectivity = await Connectivity().checkConnectivity();
      final offline = connectivity.contains(ConnectivityResult.none);
      if (offline && !AppConfig.useMockData) {
        throw StateError(AppStrings.weakConnection);
      }
      session = await _matchmakingService.findOrCreateMatch(user);
    } catch (exception) {
      error = exception.toString();
    } finally {
      isSearching = false;
      notifyListeners();
    }
  }

  Future<void> cancel(String uid) async {
    await _matchmakingService.leaveQueue(uid);
    isSearching = false;
    notifyListeners();
  }
}
