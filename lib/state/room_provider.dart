import 'package:flutter/foundation.dart';

import '../core/constants/app_strings.dart';
import '../models/room.dart';
import '../models/user_profile.dart';
import '../services/room_service.dart';

class RoomProvider extends ChangeNotifier {
  RoomProvider({RoomService? roomService})
    : _roomService = roomService ?? RoomService();

  final RoomService _roomService;

  Room? room;
  bool isLoading = false;
  String? error;

  Future<void> createRoom({
    required UserProfile host,
    required String name,
    required String mode,
    required int questionCount,
    required int maxPlayers,
    required int timerSeconds,
  }) async {
    await _run(() async {
      room = await _roomService.createRoom(
        host: host,
        name: name,
        mode: mode,
        questionCount: questionCount,
        maxPlayers: maxPlayers,
        timerSeconds: timerSeconds,
      );
    });
  }

  Future<void> joinRoom(UserProfile user, String code) async {
    await _run(() async {
      room = await _roomService.joinRoomByCode(user: user, code: code);
    }, fallback: AppStrings.roomNotFound);
  }

  Future<void> assignTeam(String uid, String teamId) async {
    final current = room;
    if (current == null) return;
    room = await _roomService.assignTeam(current, uid, teamId);
    notifyListeners();
  }

  Future<void> removePlayer(String uid) async {
    final current = room;
    if (current == null) return;
    room = await _roomService.removePlayer(current, uid);
    notifyListeners();
  }

  Future<void> startGame() async {
    final current = room;
    if (current == null) return;
    room = await _roomService.startGame(current);
    notifyListeners();
  }

  Future<void> leave(UserProfile user) async {
    final current = room;
    if (current == null) return;
    await _roomService.leaveRoom(current.id, user.uid);
    room = null;
    notifyListeners();
  }

  Future<void> _run(
    Future<void> Function() action, {
    String fallback = AppStrings.unexpectedError,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await action();
    } catch (exception) {
      error = exception.toString().isEmpty ? fallback : exception.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
