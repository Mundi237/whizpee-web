class CreditBalance {
  final bool success;
  final int credits;
  final int totalPurchased;
  final int totalSpent;

  CreditBalance({
    required this.success,
    required this.credits,
    required this.totalPurchased,
    required this.totalSpent,
  });

  factory CreditBalance.fromMap(Map<String, dynamic> map) {
    return CreditBalance(
      success: map['success'] ?? false,
      credits: map['credits'] ?? 0,
      totalPurchased: map['totalPurchased'] ?? 0,
      totalSpent: map['totalSpent'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'credits': credits,
      'totalPurchased': totalPurchased,
      'totalSpent': totalSpent,
    };
  }
}
