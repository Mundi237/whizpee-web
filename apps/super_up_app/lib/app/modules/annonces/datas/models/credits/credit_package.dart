class CreditPackage {
  final String id;
  final String name;
  final int amount;
  final int credits;
  final int bonusCredits;

  CreditPackage({
    required this.id,
    required this.name,
    required this.amount,
    required this.credits,
    required this.bonusCredits,
  });

  int get totalCredits => credits + bonusCredits;

  factory CreditPackage.fromMap(Map<String, dynamic> map) {
    return CreditPackage(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      amount: map['amount'] ?? 0,
      credits: map['credits'] ?? 0,
      bonusCredits: map['bonusCredits'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'credits': credits,
      'bonusCredits': bonusCredits,
    };
  }
}
