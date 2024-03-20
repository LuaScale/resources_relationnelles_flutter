class Commentaire {
  final int id;
  final String contenu;
  final int idRessource;
  final bool isAccepte;
  final int idUtilisateur;
  final DateTime dateCreation;
  final DateTime dateSuppression;

  const Commentaire({
    required this.id,
    required this.contenu,
    required this.idRessource,
    required this.isAccepte,
    required this.idUtilisateur,
    required this.dateCreation,
    required this.dateSuppression,
  });

  factory Commentaire.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id' : int id,
        'contenu' : String contenu,
        'idRessource' : int idRessource,
        'isAccepte' : bool isAccepte,
        'idUtilisateur' : int idUtilisateur,
        'dateCreation' : DateTime dateCreation,
        'dateSuppression' : DateTime dateSuppression,
      } =>
      Commentaire(
        id: id,
        contenu: contenu,
        idRessource: idRessource,
        isAccepte: isAccepte,
        idUtilisateur: idUtilisateur,
        dateCreation: dateCreation,
        dateSuppression: dateSuppression,
      ),
      _ => throw const FormatException('Failed to create a Commentaire from JSON data.')
    };
  }
}