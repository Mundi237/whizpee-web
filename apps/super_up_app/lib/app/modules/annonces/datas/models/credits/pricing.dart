class Pricing {
  final bool success;
  final PricingRules pricing;
  final List<CreditPackage> packages;

  Pricing({
    required this.success,
    required this.pricing,
    required this.packages,
  });

  factory Pricing.fromMap(Map<String, dynamic> map) {
    return Pricing(
      success: map['success'] ?? false,
      pricing: PricingRules.fromMap(map['pricing'] ?? {}),
      packages: (map['packages'] as List?)
              ?.map((e) => CreditPackage.fromMap(e))
              .toList() ??
          [],
    );
  }
}

class PricingRules {
  final int minAmount;
  final int maxAmount;
  final int minCredits;
  final int maxCredits;
  final double conversionRate;

  PricingRules({
    required this.minAmount,
    required this.maxAmount,
    required this.minCredits,
    required this.maxCredits,
    required this.conversionRate,
  });

  factory PricingRules.fromMap(Map<String, dynamic> map) {
    return PricingRules(
      minAmount: map['minAmount'] ?? 100,
      maxAmount: map['maxAmount'] ?? 1000000,
      minCredits: map['minCredits'] ?? 10,
      maxCredits: map['maxCredits'] ?? 100000,
      conversionRate: (map['conversionRate'] ?? 10.0).toDouble(),
    );
  }

  int creditsFromAmount(int amount) {
    return (amount / conversionRate).floor();
  }

  int amountFromCredits(int credits) {
    return (credits * conversionRate).floor();
  }
}

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
