class CreditPurchase {
  final String id;
  final String userId;
  final int amount;
  final int credits;
  final int bonusCredits;
  final String? packageId;
  final String paymentProvider;
  final String paymentDirection;
  final String status;
  final String? payToken;
  final String? transactionId;
  final DateTime createdAt;
  final DateTime? completedAt;
  final Map<String, dynamic>? metadata;

  CreditPurchase({
    required this.id,
    required this.userId,
    required this.amount,
    required this.credits,
    required this.bonusCredits,
    this.packageId,
    required this.paymentProvider,
    required this.paymentDirection,
    required this.status,
    this.payToken,
    this.transactionId,
    required this.createdAt,
    this.completedAt,
    this.metadata,
  });

  factory CreditPurchase.fromMap(Map<String, dynamic> map) {
    return CreditPurchase(
      id: map['_id'] ?? map['id'] ?? '',
      userId: map['userId'] ?? '',
      amount: map['amount'] ?? 0,
      credits: map['credits'] ?? 0,
      bonusCredits: map['bonusCredits'] ?? 0,
      packageId: map['packageId'],
      paymentProvider: map['paymentProvider'] ?? '',
      paymentDirection: map['paymentDirection'] ?? '',
      status: map['status'] ?? 'pending',
      payToken: map['payToken'],
      transactionId: map['transactionId'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
      metadata: map['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userId': userId,
      'amount': amount,
      'credits': credits,
      'bonusCredits': bonusCredits,
      'packageId': packageId,
      'paymentProvider': paymentProvider,
      'paymentDirection': paymentDirection,
      'status': status,
      'payToken': payToken,
      'transactionId': transactionId,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  int get totalCredits => credits + bonusCredits;
  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed' || status == 'success';
  bool get isFailed => status == 'failed' || status == 'error';
}
