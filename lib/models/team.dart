class Team {
  const Team({
    required this.id,
    required this.name,
    required this.color,
    required this.emoji,
    required this.playerIds,
    required this.score,
    this.describerIndex = 0,
    this.roundScores = const [],
  });

  final String id;
  final String name;
  final String color;       // hex color e.g. '#EF4444'
  final String emoji;       // e.g. '🔴'
  final List<String> playerIds;
  final int score;
  final int describerIndex; // ← يتقدم +1 كل مرة يصف فيها هذا الفريق
  final List<int> roundScores;

  // ===== Computed =====

  /// UID اللاعب الذي سيصف في الدور القادم لهذا الفريق.
  String? get currentDescriberUid {
    if (playerIds.isEmpty) return null;
    return playerIds[describerIndex % playerIds.length];
  }

  int get playerCount => playerIds.length;
  int get roundsPlayed => roundScores.length;

  // ===== Presets for common teams =====

  static const List<_TeamPreset> _presets = [
    _TeamPreset(id: 'red', name: 'الفريق الأحمر', color: '#EF4444', emoji: '🔴'),
    _TeamPreset(id: 'blue', name: 'الفريق الأزرق', color: '#3B82F6', emoji: '🔵'),
    _TeamPreset(id: 'green', name: 'الفريق الأخضر', color: '#22C55E', emoji: '🟢'),
    _TeamPreset(id: 'yellow', name: 'الفريق الذهبي', color: '#EAB308', emoji: '🟡'),
  ];

  static Team fromPreset(int index) {
    final p = _presets[index % _presets.length];
    return Team(
      id: p.id,
      name: p.name,
      color: p.color,
      emoji: p.emoji,
      playerIds: const [],
      score: 0,
    );
  }

  // ===== Serialization =====

  factory Team.fromJson(Map<String, dynamic> json) => Team(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    color: json['color']?.toString() ?? '#3B82F6',
    emoji: json['emoji']?.toString() ?? '🎯',
    playerIds: (json['playerIds'] as List<dynamic>? ?? const [])
        .map((item) => item.toString())
        .toList(growable: false),
    score: (json['score'] as num?)?.toInt() ?? 0,
    describerIndex: (json['describerIndex'] as num?)?.toInt() ?? 0,
    roundScores: (json['roundScores'] as List<dynamic>? ?? const [])
        .map((item) => (item as num).toInt())
        .toList(growable: false),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'color': color,
    'emoji': emoji,
    'playerIds': playerIds,
    'score': score,
    'describerIndex': describerIndex,
    'roundScores': roundScores,
  };

  Team copyWith({
    String? id,
    String? name,
    String? color,
    String? emoji,
    List<String>? playerIds,
    int? score,
    int? describerIndex,
    List<int>? roundScores,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      emoji: emoji ?? this.emoji,
      playerIds: playerIds ?? this.playerIds,
      score: score ?? this.score,
      describerIndex: describerIndex ?? this.describerIndex,
      roundScores: roundScores ?? this.roundScores,
    );
  }

  Team addPoints(int points) => copyWith(score: score + points);

  Team recordRoundScore(int roundPoints) => copyWith(
    roundScores: [...roundScores, roundPoints],
    score: score + roundPoints,
  );

  Team advanceDescriber() =>
      copyWith(describerIndex: describerIndex + 1);
}

class _TeamPreset {
  const _TeamPreset({
    required this.id,
    required this.name,
    required this.color,
    required this.emoji,
  });

  final String id;
  final String name;
  final String color;
  final String emoji;
}
