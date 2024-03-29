class Utilisateur {
  final String nom;
  final String prenom;
  final String? email;
  final String? password;

  const Utilisateur({
    required this.nom,
    required this.prenom,
    this.email,
    this.password,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json){
    final prenom = json['firstname'] as String;
    final nom = json['lastname'] as String;
    final email = json['email'] as String?;
    final password = json['plainPassword'] as String?;
    return Utilisateur(nom: nom, prenom: prenom, email: email, password: password);
    }
}