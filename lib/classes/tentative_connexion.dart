class TentativeConnexion {
  final int id;
  final DateTime dateTentative;
  final int idUtilisateur;

  const TentativeConnexion({
    required this.id,
    required this.dateTentative,
    required this.idUtilisateur,
  });

  factory TentativeConnexion.fromJson(Map<String, dynamic> json){
    return switch(json) {
      {
        'id' : int id,
        'dateTentative' : DateTime dateTentative,
        'idUtilisateur' : int idUtilisateur,
      } =>
      TentativeConnexion(
        id: id,
        dateTentative: dateTentative,
        idUtilisateur: idUtilisateur,
      ),
      _ => throw const FormatException('Failed to create a TentativeConnexion from JSON data.')
    };
  }
}