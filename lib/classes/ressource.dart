
import 'package:resources_relationnelles_flutter/classes/commentaire.dart';
import 'package:resources_relationnelles_flutter/classes/partage.dart';
import 'package:resources_relationnelles_flutter/classes/relation_type.dart';
import 'package:resources_relationnelles_flutter/classes/ressource_categorie.dart';
import 'package:resources_relationnelles_flutter/classes/ressource_type.dart';
import 'package:resources_relationnelles_flutter/classes/utilisateur.dart';

class Ressource {
  final int id;
  final String titre;
  final String description;
  final String? contenu;
  final RessourceType? ressourceType;
  final RessourceCategorie ressourceCategorie;
  final RelationType relationType;
  final bool? isVisible;
  final bool? isAccepte;
  final Utilisateur utilisateur;
  final List<Commentaire>? commentaires;
  final List<Partage>? partages;
  final DateTime? dateCreation;
  final DateTime dateModification;

  const Ressource({
    required this.id,
    required this.titre,
    required this.description,
    this.contenu,
    this.ressourceType,
    required this.ressourceCategorie,
    required this.relationType,
    this.isVisible,
    this.isAccepte,
    required this.utilisateur,
    this.commentaires,
    this.partages,
    this.dateCreation,
    required this.dateModification,
  });

  factory Ressource.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final titre = json['title'] as String;
    final description = json['description'] as String;
    final contenu = json['content'] as String?;
    RessourceType? ressourceType = json["ressourceType"] == null ? null : RessourceType.fromJson(json["ressourceType"] as Map<String, dynamic>);
    RessourceCategorie ressourceCategorie = RessourceCategorie.fromJson(json["ressourceCategory"] as Map<String, dynamic>);
    RelationType relationType = RelationType.fromJson(json["relationType"] as Map<String, dynamic>);
    final isVisible = json['visible'] as bool?;
    final isAccepte = json['accepted'] as bool?;
    Utilisateur utilisateur = Utilisateur.fromJson(json["user"] as Map<String, dynamic>);
    var commentaires = json['comments'] == null ? null : json['comments']['hydra:member'] as List<dynamic>?;
    final partages = json['shares'] as List<Partage>?;
    final dateCreation = json['createdAt'] as DateTime?;
    final dateModification = DateTime.parse(json['updateAt']);
    return Ressource(
        id: id,
        titre: titre,
        description: description,
        contenu: contenu,
        ressourceType: ressourceType,
        ressourceCategorie: ressourceCategorie,
        relationType: relationType,
        isVisible: isVisible,
        isAccepte: isAccepte,
        utilisateur: utilisateur,
        commentaires: commentaires != null
            ? commentaires.map((commentaire) =>
            Commentaire.fromJson(commentaire as Map<String, dynamic>)).toList()
            : <Commentaire>[],
        partages: partages,
        dateCreation: dateCreation,
        dateModification:  dateModification
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': titre,
      'description': description,
      'content': contenu,
      'ressourceType': ressourceType?.toJson(),
      'ressourceCategory': ressourceCategorie.toJson(),
      'relationType': relationType.toJson(),
    };
  }
}