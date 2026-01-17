class PaymentTransaction {
  final String? payToken;
  final String? transactionId;
  final String status;
  final String message;
  final int amount;
  final String? phoneNumber;
  final String? provider;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  PaymentTransaction({
    this.payToken,
    this.transactionId,
    required this.status,
    required this.message,
    required this.amount,
    this.phoneNumber,
    this.provider,
    required this.createdAt,
    this.metadata,
  });

  factory PaymentTransaction.fromMap(Map<String, dynamic> map) {
    return PaymentTransaction(
      payToken: map['payToken'],
      transactionId: map['transactionId'] ?? map['transaction_id'],
      status: map['status'] ?? 'pending',
      message: map['message'] ?? '',
      amount: map['amount'] ?? 0,
      phoneNumber: map['phoneNumber'] ?? map['phone_number'],
      provider: map['provider'] ?? map['paymentProvider'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      metadata: map['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'payToken': payToken,
      'transactionId': transactionId,
      'status': status,
      'message': message,
      'amount': amount,
      'phoneNumber': phoneNumber,
      'provider': provider,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  bool get isPending => status == 'pending';
  bool get isSuccess => status == 'success' || status == 'completed';
  bool get isFailed => status == 'failed' || status == 'error';
}
