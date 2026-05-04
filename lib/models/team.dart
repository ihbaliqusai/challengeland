class Team {
  const Team({
    required this.id,
    required this.name,
    required this.color,
    required this.playerIds,
    required this.score,
  });

  final String id;
  final String name;
  final String color;
  final List<String> playerIds;
  final int score;

  factory Team.fromJson(Map<String, dynamic> json) => Team(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    color: json['color']?.toString() ?? '#2563EB',
    playerIds: (json['playerIds'] as List<dynamic>? ?? const [])
        .map((item) => item.toString())
        .toList(growable: false),
    score: (json['score'] as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'color': color,
    'playerIds': playerIds,
    'score': score,
  };

  Team copyWith({
    String? id,
    String? name,
    String? color,
    List<String>? playerIds,
    int? score,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      playerIds: playerIds ?? this.playerIds,
      score: score ?? this.score,
    );
  }
}
