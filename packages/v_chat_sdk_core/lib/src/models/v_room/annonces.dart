// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/src/models/v_room/boost.dart';
import 'package:v_chat_sdk_core/src/models/v_room/categorie.dart';

class Annonces {
  final String id;
  final String title;
  final String description;
  final Categorie? categorie;
  final String? categorieId;
  final List<String>? images;
  final DateTime createdAt;
  final dynamic location;
  final String? ville;
  final String? quartier;
  final SBaseUser? user;
  final String? userId;
  final bool isBoosted;
  final DateTime? boostedUntil;
  final String? status;
  final int views;
  final Boost? boostTypeId;
  Annonces({
    required this.title,
    required this.description,
    required this.id,
    required this.createdAt,
    this.user,
    this.location,
    this.categorie,
    this.categorieId,
    this.images,
    this.ville,
    this.quartier,
    this.boostedUntil,
    this.status,
    this.isBoosted = false,
    this.userId,
    this.views = 0,
    this.boostTypeId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'categorie': categorie?.toMap(),
      'categorieId': categorieId,
      'images': images,
      '_id': id,
      'createdAt': createdAt,
      'user': user?.toMap(),
      'location': location,
      'ville': ville,
      'quartier': quartier,
      'isBoosted': isBoosted,
      'boostedUntil': boostedUntil?.toIso8601String(),
      'status': status,
      'views': views,
      'boostTypeId': boostTypeId?.toJson(),
    };
  }

  factory Annonces.fromMap(Map<String, dynamic> map) {
    final SBaseUser? sBaseUser = map['userId'] is Map
        ? SBaseUser.fromMap(map['userId'])
        : map['userInfo'] is Map
            ? SBaseUser.fromMap(map['userInfo'])
            : null;
    return Annonces(
        id: map['_id'],
        title: map['title'],
        description: map['description'] ?? '',
        categorie: map['categorie'] is Map
            ? Categorie.fromMap(map['categorie'])
            : null,
        boostTypeId: map['boostTypeId'] is Map
            ? Boost.fromJson(map['boostTypeId'])
            : null,
        categorieId: map['categorie'] is Map
            ? map['categorie']['_id']
            : map['categorie'],
        images:
            map['images'] != null ? List<String>.from((map['images'])) : null,
        location: map['location'],
        createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
        user: sBaseUser,
        userId: map['userId'] is String ? map['userId'] : sBaseUser?.id,
        ville: map['ville'],
        quartier: map['quartier'],
        isBoosted: map['isBoosted'] ?? false,
        boostedUntil: map['boostedUntil'] != null
            ? DateTime.tryParse(map['boostedUntil'])
            : null,
        status: map['status'],
        views: int.tryParse(map['views'].toString()) ?? 0);
  }

  bool get isMine => user?.id == AppAuth.myId;
  bool get isPublished => status == "published";

  @override
  String toString() {
    return 'Annonces(title: $title, description: $description, categorie: $categorie, categorieId: $categorieId, images: $images)';
  }

  @override
  bool operator ==(covariant Annonces other) {
    if (identical(this, other)) return true;

    return other.title == title && other.id == id;
  }

  @override
  int get hashCode {
    return title.hashCode ^ id.hashCode;
  }

  Annonces copyWith({
    String? id,
    String? title,
    String? description,
    Categorie? categorie,
    String? categorieId,
    List<String>? images,
    DateTime? createdAt,
    dynamic location,
    SBaseUser? user,
    String? ville,
    String? quartier,
    int? views,
  }) {
    return Annonces(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categorie: categorie ?? this.categorie,
      categorieId: categorieId ?? this.categorieId,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      location: location ?? this.location,
      user: user ?? this.user,
      ville: ville ?? this.ville,
      quartier: quartier ?? this.quartier,
      views: views ?? this.views,
    );
  }
}
