import '../core/utils/date_utils.dart';
import 'room_player.dart';
import 'team.dart';

class Room {
  const Room({
    required this.id,
    required this.code,
    required this.name,
    required this.hostId,
    required this.mode,
    required this.questionCount,
    required this.maxPlayers,
    required this.timerSeconds,
    required this.status,
    required this.players,
    required this.teams,
    this.gameSessionId,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String code;
  final String name;
  final String hostId;
  final String mode;
  final int questionCount;
  final int maxPlayers;
  final int timerSeconds;
  final String status;
  final List<RoomPlayer> players;
  final List<Team> teams;
  final String? gameSessionId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isFull => players.length >= maxPlayers;
  bool get isWaiting => status == 'waiting';

  factory Room.fromJson(Map<String, dynamic> json) => Room(
    id: json['id']?.toString() ?? '',
    code: json['code']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    hostId: json['hostId']?.toString() ?? '',
    mode: json['mode']?.toString() ?? 'private_battle',
    questionCount: (json['questionCount'] as num?)?.toInt() ?? 5,
    maxPlayers: (json['maxPlayers'] as num?)?.toInt() ?? 2,
    timerSeconds: (json['timerSeconds'] as num?)?.toInt() ?? 15,
    status: json['status']?.toString() ?? 'waiting',
    players: (json['players'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(RoomPlayer.fromJson)
        .toList(growable: false),
    teams: (json['teams'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(Team.fromJson)
        .toList(growable: false),
    gameSessionId: json['gameSessionId']?.toString(),
    createdAt: ChallengeDateUtils.parse(json['createdAt']),
    updatedAt: ChallengeDateUtils.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'name': name,
    'hostId': hostId,
    'mode': mode,
    'questionCount': questionCount,
    'maxPlayers': maxPlayers,
    'timerSeconds': timerSeconds,
    'status': status,
    'players': players.map((item) => item.toJson()).toList(),
    'teams': teams.map((item) => item.toJson()).toList(),
    'gameSessionId': gameSessionId,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  Room copyWith({
    String? id,
    String? code,
    String? name,
    String? hostId,
    String? mode,
    int? questionCount,
    int? maxPlayers,
    int? timerSeconds,
    String? status,
    List<RoomPlayer>? players,
    List<Team>? teams,
    String? gameSessionId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Room(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      hostId: hostId ?? this.hostId,
      mode: mode ?? this.mode,
      questionCount: questionCount ?? this.questionCount,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      status: status ?? this.status,
      players: players ?? this.players,
      teams: teams ?? this.teams,
      gameSessionId: gameSessionId ?? this.gameSessionId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
