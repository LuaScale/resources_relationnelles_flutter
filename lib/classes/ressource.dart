import 'dart:convert';

import 'package:resources_relationnelles_flutter/classes/commentaire.dart';
import 'package:resources_relationnelles_flutter/classes/partage.dart';
import 'package:resources_relationnelles_flutter/classes/ressource_type.dart';
import 'package:resources_relationnelles_flutter/classes/utilisateur.dart';

class Ressource {
  final String titre;
  final String description;
  final String? contenu;
  final RessourceType ressourceType;
  final bool? isVisible;
  final bool? isAccepte;
  final Utilisateur utilisateur;
  final List<Commentaire>? commentaires;
  final List<Partage>? partages;
  final DateTime? dateCreation;
  final DateTime dateModification;

  const Ressource({
    required this.titre,
    required this.description,
    this.contenu,
    required this.ressourceType,
    this.isVisible,
    this.isAccepte,
    required this.utilisateur,
    this.commentaires,
    this.partages,
    this.dateCreation,
    required this.dateModification,
  });

  factory Ressource.fromJson(Map<String, dynamic> json) {
    final titre = json['title'] as String;
    final description = json['description'] as String;
    final contenu = json['content'] as String?;
    RessourceType ressourceType = RessourceType.fromJson(json["ressourceType"] as Map<String, dynamic>);
    final isVisible = json['visible'] as bool?;
    final isAccepte = json['accepted'] as bool?;
    Utilisateur utilisateur = Utilisateur.fromJson(json["user"] as Map<String, dynamic>);
    final commentaires = json['comments'] as List<Commentaire>?;
    final partages = json['shares'] as List<Partage>?;
    final dateCreation = json['createdAt'] as DateTime?;
    final dateModification = DateTime.parse(json['updateAt']);
    return Ressource(
        titre: titre,
        description: description,
        contenu: contenu,
        ressourceType: ressourceType,
        isVisible: isVisible,
        isAccepte: isAccepte,
        utilisateur: utilisateur,
        commentaires: commentaires,
        partages: partages,
        dateCreation: dateCreation,
        dateModification:  dateModification
    );
  }
}