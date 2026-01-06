class Package {
  final String id;
  final String name;
  final double amount;
  final int credits;
  final int bonusCredits;
  final double bonusPercentage;
  final String description;
  final double? savings;

  Package({
    required this.id,
    required this.name,
    required this.amount,
    required this.credits,
    required this.bonusCredits,
    required this.bonusPercentage,
    required this.description,
    this.savings,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      name: json['name'],
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      credits: int.tryParse(json['credits'].toString()) ?? 0,
      bonusCredits: int.tryParse(json['bonusCredits'].toString()) ?? 0,
      bonusPercentage: double.tryParse(json['bonusPercentage'].toString()) ?? 0,
      description: json['description'],
      savings: json['savings'] != null
          ? double.tryParse(json['savings'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'credits': credits,
      'bonusCredits': bonusCredits,
      'bonusPercentage': bonusPercentage,
      'description': description,
      'savings': savings,
    };
  }
}
