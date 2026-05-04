import '../core/utils/date_utils.dart';

class RoomPlayer {
  const RoomPlayer({
    required this.uid,
    required this.username,
    this.photoUrl,
    this.teamId,
    required this.isHost,
    required this.isReady,
    required this.score,
    this.joinedAt,
  });

  final String uid;
  final String username;
  final String? photoUrl;
  final String? teamId;
  final bool isHost;
  final bool isReady;
  final int score;
  final DateTime? joinedAt;

  factory RoomPlayer.fromJson(Map<String, dynamic> json) => RoomPlayer(
    uid: json['uid']?.toString() ?? '',
    username: json['username']?.toString() ?? 'لاعب',
    photoUrl: json['photoUrl']?.toString(),
    teamId: json['teamId']?.toString(),
    isHost: json['isHost'] == true,
    isReady: json['isReady'] != false,
    score: (json['score'] as num?)?.toInt() ?? 0,
    joinedAt: ChallengeDateUtils.parse(json['joinedAt']),
  );

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'username': username,
    'photoUrl': photoUrl,
    'teamId': teamId,
    'isHost': isHost,
    'isReady': isReady,
    'score': score,
    'joinedAt': joinedAt?.toIso8601String(),
  };

  RoomPlayer copyWith({
    String? uid,
    String? username,
    String? photoUrl,
    String? teamId,
    bool? isHost,
    bool? isReady,
    int? score,
    DateTime? joinedAt,
  }) {
    return RoomPlayer(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      photoUrl: photoUrl ?? this.photoUrl,
      teamId: teamId ?? this.teamId,
      isHost: isHost ?? this.isHost,
      isReady: isReady ?? this.isReady,
      score: score ?? this.score,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
