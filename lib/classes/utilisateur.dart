class Utilisateur {
  final int id;
  final String email;
  final List roles;
  final String nom;
  final String prenom;
  final String password;
  final List tentativesConnexion;
  final List ressources;
  final List commentaires;
  final List partages;
  final String pseudo;

  const Utilisateur({
    required this.id,
    required this.email,
    required this.roles,
    required this.nom,
    required this.prenom,
    required this.password,
    required this.tentativesConnexion,
    required this.ressources,
    required this.commentaires,
    required this.partages,
    required this.pseudo,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json){
    return switch(json) {
      {
        'id' : int id,
        'email' : String email,
        'roles' : List roles,
        'nom' : String nom,
        'prenom' : String prenom,
        'password' : String password,
        'tentativesConnexion' : List tentativesConnexion,
        'ressources' : List ressources,
        'commentaires' : List commentaires,
        'partages' : List partages,
        'pseudo' : String pseudo,
      } =>
      Utilisateur(
        id: id,
        email: email,
        roles: roles,
        nom: nom,
        prenom: prenom,
        password: password,
        tentativesConnexion: tentativesConnexion,
        ressources: ressources,
        commentaires: commentaires,
        partages: partages,
        pseudo: pseudo,
      ),
      _ => throw const FormatException('Failed to create a Utilisateur from JSON data.')
    };
  }
}