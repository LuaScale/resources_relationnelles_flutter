class Ressource {
  final int id;
  final String titre;
  final String description;
  final String contenu;
  final int idTypeRessource;
  final bool isVisible;
  final bool isAccepte;
  final int idUtilisateur;
  final List commentaires;
  final List partages;
  final DateTime dateCreation;
  final DateTime dateModification;

  const Ressource({
    required this.id,
    required this.titre,
    required this.description,
    required this.contenu,
    required this.idTypeRessource,
    required this.isVisible,
    required this.isAccepte,
    required this.idUtilisateur,
    required this.commentaires,
    required this.partages,
    required this.dateCreation,
    required this.dateModification,
  });

  factory Ressource.fromJson(Map<String, dynamic> json) {
    return switch(json) {
      {
        'id' : int id,
        'titre' : String titre,
        'description' : String description,
        'contenu' : String contenu,
        'idTypeRessource' : int idTypeRessource,
        'isVisible' : bool isVisible,
        'isAccepte' : bool isAccepte,
        'idUtilisateur' : int idUtilisateur,
        'commentaires' : List commentaires,
        'partages' : List partages,
        'dateCreation' : DateTime dateCreation,
        'dateModification' : DateTime dateModification,
      } =>
      Ressource(
        id: id,
        titre: titre,
        description: description,
        contenu: contenu,
        idTypeRessource: idTypeRessource,
        isVisible: isVisible,
        isAccepte: isAccepte,
        idUtilisateur: idUtilisateur,
        commentaires: commentaires,
        partages: partages,
        dateCreation: dateCreation,
        dateModification: dateModification,
      ),
      _ => throw const FormatException('Failed to create a Ressource from JSON data.')
    };
  }
}