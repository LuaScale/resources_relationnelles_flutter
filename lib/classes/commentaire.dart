import 'package:resources_relationnelles_flutter/classes/ressource.dart';
import 'package:resources_relationnelles_flutter/classes/utilisateur.dart';

class Commentaire {
  final String id;
  final String contenu;
  final Ressource? ressource;
  final bool? isAccepte;
  final Utilisateur utilisateur;
  final DateTime dateCreation;
  final DateTime? dateSuppression;

  const Commentaire({
    required this.id,
    required this.contenu,
    this.ressource,
    this.isAccepte,
    required this.utilisateur,
    required this.dateCreation,
    this.dateSuppression,
  });

  factory Commentaire.fromJson(Map<String, dynamic> json) {
    final id = json['@id'] as String;
    final contenu = json['content'] as String;
    final ressource = json['ressource'] as Ressource?;
    final isAccepte = json['accepted'] as bool?;
    Utilisateur utilisateur = Utilisateur.fromJson(json["user"] as Map<String, dynamic>);
    final dateCreation = DateTime.parse(json['createdAt']);
    final dateSuppression = json['deletedAt'] as DateTime?;
    return Commentaire(
      id: id,
      contenu: contenu,
      ressource: ressource,
      isAccepte: isAccepte,
      utilisateur: utilisateur,
      dateCreation: dateCreation,
      dateSuppression: dateSuppression,
    );
  }
}