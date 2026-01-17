class TransactionStats {
  final int totalTransactions;
  final int totalPurchases;
  final int totalSpendings;
  final int totalBonuses;
  final int totalAmountPurchased;
  final int totalAmountSpent;
  final int totalCreditsEarned;
  final int totalCreditsSpent;

  TransactionStats({
    required this.totalTransactions,
    required this.totalPurchases,
    required this.totalSpendings,
    required this.totalBonuses,
    required this.totalAmountPurchased,
    required this.totalAmountSpent,
    required this.totalCreditsEarned,
    required this.totalCreditsSpent,
  });

  factory TransactionStats.fromMap(Map<String, dynamic> map) {
    return TransactionStats(
      totalTransactions: map['totalTransactions'] ?? 0,
      totalPurchases: map['totalPurchases'] ?? 0,
      totalSpendings: map['totalSpendings'] ?? 0,
      totalBonuses: map['totalBonuses'] ?? 0,
      totalAmountPurchased: map['totalAmountPurchased'] ?? 0,
      totalAmountSpent: map['totalAmountSpent'] ?? 0,
      totalCreditsEarned: map['totalCreditsEarned'] ?? 0,
      totalCreditsSpent: map['totalCreditsSpent'] ?? 0,
    );
  }
}
