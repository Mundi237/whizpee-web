import 'dart:convert';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class ErrorModel {
  String error;
  int? errorCode;
  ErrorModel({required this.error, this.errorCode});

  ErrorModel copyWith({String? error, int? code}) {
    return ErrorModel(error: error ?? this.error, errorCode: code ?? errorCode);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'error': error, 'code': errorCode};
  }

  factory ErrorModel.fromMap(Map<String, dynamic> map) {
    return ErrorModel(
      error: map['error'] as String,
      errorCode: int.tryParse(map['code'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorModel.fromJson(String source) =>
      ErrorModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ErrorModel(error: $error code: $errorCode )';

  @override
  bool operator ==(covariant ErrorModel other) {
    if (identical(this, other)) return true;

    return other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
