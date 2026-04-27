class Game {
  final String gameId;
  final String gameName; // Aviator, Cricket, Satta, Wagera
  final String description;
  final double minBet; // ₹10
  final double maxBet; // Unlimited
  final double multiplier; // 9x
  final String gameType;
  final bool isActive;
  final DateTime nextGameTime;
  final int durationMinutes; // 15 minutes before game starts

  Game({
    required this.gameId,
    required this.gameName,
    required this.description,
    required this.minBet,
    required this.maxBet,
    required this.multiplier,
    required this.gameType,
    required this.isActive,
    required this.nextGameTime,
    required this.durationMinutes,
  });

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      gameId: map['gameId'] ?? '',
      gameName: map['gameName'] ?? '',
      description: map['description'] ?? '',
      minBet: (map['minBet'] ?? 10).toDouble(),
      maxBet: (map['maxBet'] ?? 999999).toDouble(),
      multiplier: (map['multiplier'] ?? 9).toDouble(),
      gameType: map['gameType'] ?? '',
      isActive: map['isActive'] ?? true,
      nextGameTime: DateTime.parse(map['nextGameTime'] ?? DateTime.now().toString()),
      durationMinutes: map['durationMinutes'] ?? 15,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'gameName': gameName,
      'description': description,
      'minBet': minBet,
      'maxBet': maxBet,
      'multiplier': multiplier,
      'gameType': gameType,
      'isActive': isActive,
      'nextGameTime': nextGameTime.toString(),
      'durationMinutes': durationMinutes,
    };
  }
}
