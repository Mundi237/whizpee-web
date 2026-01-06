class Boost {
  final String title;
  final String description;
  final double price;
  final String id;
  final bool isActive;

  Boost({
    required this.title,
    required this.description,
    required this.price,
    required this.id,
    this.isActive = true,
  });

  factory Boost.fromJson(Map<String, dynamic> json) {
    return Boost(
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['amount'] as num).toDouble(),
      id: json['_id'] as String,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      '_id': id,
      'isActive': isActive,
    };
  }
}
