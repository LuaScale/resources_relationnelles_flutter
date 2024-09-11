import 'package:resources_relationnelles_flutter/classes/ressource.dart';

class Favorie {
  final String id;
  final DateTime? createdAt;
  final Ressource ressource;

  const Favorie({
    required this.id,
    required this.createdAt,
    required this.ressource,
  });

  factory Favorie.fromJson(Map<String, dynamic> json) {
    final id = json['@id'] as String;
    final createdAt = DateTime.parse(json['createdAt']);
    Ressource ressource = Ressource.fromJson(json["ressource"] as Map<String, dynamic>);
    return Favorie(id: id,createdAt: createdAt, ressource: ressource);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'ressource': ressource,
    };
  }
}