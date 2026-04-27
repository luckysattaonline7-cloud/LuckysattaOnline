class Bet {
  final String betId;
  final String userId;
  final String gameType; // aviator, cricket, satta, wagera
  final double stakeAmount;
  final double potentialWinning;
  final String status; // pending, won, lost, cancelled
  final String gameSelection; // for cricket, satta selections
  final double multiplier; // 9x for ₹10 = ₹900
  final DateTime createdAt;
  final DateTime? gameTime;
  final String paymentStatus; // pending, completed, rejected
  final String? paymentScreenshot;
  final String? result;

  Bet({
    required this.betId,
    required this.userId,
    required this.gameType,
    required this.stakeAmount,
    required this.potentialWinning,
    required this.status,
    required this.gameSelection,
    required this.multiplier,
    required this.createdAt,
    this.gameTime,
    required this.paymentStatus,
    this.paymentScreenshot,
    this.result,
  });

  factory Bet.fromMap(Map<String, dynamic> map) {
    return Bet(
      betId: map['betId'] ?? '',
      userId: map['userId'] ?? '',
      gameType: map['gameType'] ?? '',
      stakeAmount: (map['stakeAmount'] ?? 0).toDouble(),
      potentialWinning: (map['potentialWinning'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
      gameSelection: map['gameSelection'] ?? '',
      multiplier: (map['multiplier'] ?? 1).toDouble(),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toString()),
      gameTime: map['gameTime'] != null ? DateTime.parse(map['gameTime']) : null,
      paymentStatus: map['paymentStatus'] ?? 'pending',
      paymentScreenshot: map['paymentScreenshot'],
      result: map['result'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'betId': betId,
      'userId': userId,
      'gameType': gameType,
      'stakeAmount': stakeAmount,
      'potentialWinning': potentialWinning,
      'status': status,
      'gameSelection': gameSelection,
      'multiplier': multiplier,
      'createdAt': createdAt.toString(),
      'gameTime': gameTime?.toString(),
      'paymentStatus': paymentStatus,
      'paymentScreenshot': paymentScreenshot,
      'result': result,
    };
  }
}
