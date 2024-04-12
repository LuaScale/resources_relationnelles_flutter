class Utilisateur {
  final int? id;
  final String nom;
  final String prenom;
  final String? email;
  final String? password;
  final List? roles;

  const Utilisateur({
    this.id,
    required this.nom,
    required this.prenom,
    this.email,
    this.password,
    this.roles,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json){
    final id = json['id'] as int?;
    final prenom = json['firstname'] as String;
    final nom = json['lastname'] as String;
    final email = json['email'] as String?;
    final password = json['password'] as String?;
    final roles = json['roles'] as List?;
    return Utilisateur(id: id, nom: nom, prenom: prenom, email: email, password: password, roles: roles);
    }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': prenom,
      'lastname': nom,
      'email': email,
      'roles': roles,
    };
  }
}