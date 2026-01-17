class CreditTransaction {
  final String id;
  final String userId;
  final String type;
  final int amount;
  final int credits;
  final String? description;
  final String? reference;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  CreditTransaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.credits,
    this.description,
    this.reference,
    required this.createdAt,
    this.metadata,
  });

  factory CreditTransaction.fromMap(Map<String, dynamic> map) {
    return CreditTransaction(
      id: map['_id'] ?? map['id'] ?? '',
      userId: map['userId'] ?? '',
      type: map['type'] ?? '',
      amount: map['amount'] ?? 0,
      credits: map['credits'] ?? 0,
      description: map['description'],
      reference: map['reference'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      metadata: map['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userId': userId,
      'type': type,
      'amount': amount,
      'credits': credits,
      'description': description,
      'reference': reference,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  bool get isPurchase => type == 'purchase' || type == 'deposit';
  bool get isSpending => type == 'spending' || type == 'expense';
  bool get isBonus => type == 'bonus';
}
