class CrediWallet {
  final double credits;
  final double totalPurchased;
  final double totalSpent;

  CrediWallet({
    required this.credits,
    required this.totalPurchased,
    required this.totalSpent,
  });

  factory CrediWallet.fromJson(Map<String, dynamic> json) {
    return CrediWallet(
      credits: double.tryParse(json['credits'].toString()) ?? 0,
      totalPurchased: double.tryParse(json['totalPurchased'].toString()) ?? 0,
      totalSpent: double.tryParse(json['totalSpent'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'credits': credits,
      'totalPurchased': totalPurchased,
      'totalSpent': totalSpent,
    };
  }
}
