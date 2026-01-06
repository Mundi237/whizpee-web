class PackageTransaction {
  final String id;
  final String userId;
  final double credits;
  final double amount;
  final String currency;
  final String status;
  final String paymentProvider;
  final String paymentDirection;
  final String packageId;
  final double bonusCredits;
  final DateTime? createdAt;

  PackageTransaction({
    required this.id,
    required this.userId,
    required this.credits,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paymentProvider,
    required this.paymentDirection,
    required this.packageId,
    required this.bonusCredits,
    this.createdAt,
  });

  factory PackageTransaction.fromJson(Map<String, dynamic> json) {
    return PackageTransaction(
        id: json['_id'],
        userId: json['userId'],
        credits: json['credits'].toDouble(),
        amount: json['amount'].toDouble(),
        currency: json['currency'],
        status: json['status'],
        paymentProvider: json['paymentProvider'],
        paymentDirection: json['paymentDirection'],
        packageId: json['packageId'],
        bonusCredits: json['bonusCredits'].toDouble(),
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'])
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'credits': credits,
      'amount': amount,
      'currency': currency,
      'status': status,
      'paymentProvider': paymentProvider,
      'paymentDirection': paymentDirection,
      'packageId': packageId,
      'bonusCredits': bonusCredits,
    };
  }

  bool get isDeposit {
    return paymentDirection == PaymentDirection.deposit.value;
  }
}

enum PaymentDirection {
  deposit('deposit'),
  withdraw('withdraw');

  final String value;
  const PaymentDirection(this.value);
}

enum TransactionStatus {
  pending('pending'),
  success('success'),
  failed('failed');

  final String value;
  const TransactionStatus(this.value);
}
