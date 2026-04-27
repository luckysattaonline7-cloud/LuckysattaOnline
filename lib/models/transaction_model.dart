class Transaction {
  final String transactionId;
  final String userId;
  final double amount;
  final String type; // deposit, withdrawal, win, loss
  final String status; // pending, completed, failed
  final String paymentMethod; // whatsapp, bank_transfer, upi
  final String? screenshot;
  final String? notes;
  final DateTime createdAt;
  final String? relatedBetId;

  Transaction({
    required this.transactionId,
    required this.userId,
    required this.amount,
    required this.type,
    required this.status,
    required this.paymentMethod,
    this.screenshot,
    this.notes,
    required this.createdAt,
    this.relatedBetId,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      transactionId: map['transactionId'] ?? '',
      userId: map['userId'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      type: map['type'] ?? '',
      status: map['status'] ?? 'pending',
      paymentMethod: map['paymentMethod'] ?? '',
      screenshot: map['screenshot'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toString()),
      relatedBetId: map['relatedBetId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'userId': userId,
      'amount': amount,
      'type': type,
      'status': status,
      'paymentMethod': paymentMethod,
      'screenshot': screenshot,
      'notes': notes,
      'createdAt': createdAt.toString(),
      'relatedBetId': relatedBetId,
    };
  }
}
