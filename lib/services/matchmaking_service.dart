import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/app_config.dart';
import '../core/constants/firestore_collections.dart';
import '../models/game_session.dart';
import '../models/user_profile.dart';
import 'mock_data_service.dart';

class MatchmakingService {
  MatchmakingService({
    MockDataService? mockDataService,
    FirebaseFirestore? firestore,
  }) : _mockDataService = mockDataService ?? MockDataService(),
       _firestore = firestore;

  final MockDataService _mockDataService;
  final FirebaseFirestore? _firestore;
  FirebaseFirestore get _db => _firestore ?? FirebaseFirestore.instance;

  Future<void> joinQueue(UserProfile user) async {
    if (AppConfig.useMockData) return;
    await _db
        .collection(FirestoreCollections.matchmakingQueue)
        .doc(user.uid)
        .set({
          'uid': user.uid,
          'username': user.username,
          'rating': user.rating,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  Future<void> leaveQueue(String uid) async {
    if (AppConfig.useMockData) return;
    await _db
        .collection(FirestoreCollections.matchmakingQueue)
        .doc(uid)
        .delete();
  }

  Stream<GameSession?> listenForMatch(String uid) {
    if (AppConfig.useMockData) return const Stream<GameSession?>.empty();
    return _db
        .collection(FirestoreCollections.gameSessions)
        .where('playerIds', arrayContains: uid)
        .where('status', isEqualTo: 'active')
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return GameSession.fromJson(snapshot.docs.first.data());
        });
  }

  Future<GameSession> findOrCreateMatch(UserProfile user) async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 900));
      return _mockDataService.startMockMatch(player: user);
    }
    await joinQueue(user);
    // TODO: Move matchmaking pairing and room creation to Cloud Functions.
    throw StateError('المطابقة المباشرة تحتاج Cloud Functions في الإنتاج.');
  }

  Future<void> cleanupStaleQueueEntries() async {
    if (AppConfig.useMockData) return;
    // TODO: Run this from a scheduled Cloud Function in production.
  }
}
