import 'dart:convert';

class City {
  final String name;
  final int id;
  City({
    required this.name,
    required this.id,
  });

  City copyWith({
    String? name,
    int? id,
  }) {
    return City(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
    };
  }

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      name: map['name'] as String,
      id: map['id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory City.fromJson(String source) =>
      City.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'City(name: $name, id: $id)';

  @override
  bool operator ==(covariant City other) {
    if (identical(this, other)) return true;

    return other.name == name && other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
