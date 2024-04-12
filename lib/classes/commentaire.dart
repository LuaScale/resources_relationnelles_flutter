import 'package:resources_relationnelles_flutter/classes/ressource.dart';
import 'package:resources_relationnelles_flutter/classes/utilisateur.dart';

class Commentaire {
  final int id;
  final String contenu;
  final String? ressource;
  final bool? isAccepte;
  final dynamic utilisateur;
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
    dynamic utilisateur;
    var i = json['@id'] as String;
    i = i.substring(14);
    final id = int.parse(i);
    final contenu = json['content'] as String;
    final ressource = json['ressource'] as String?;
    final isAccepte = json['accepted'] as bool?;
    if(json['user'] is Map<String, dynamic>){
      Utilisateur utilisateur = Utilisateur.fromJson(json["user"] as Map<String, dynamic>);
    } else {
      final utilisateur = json['user'] as String;
    }
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

  int getIdRessource(){
    if(ressource != null){
      String? r = ressource?.substring(16);
      return int.parse(r!);
    }
    return 0;
  }
}