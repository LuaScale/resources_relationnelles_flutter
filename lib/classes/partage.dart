class Partage {
  final int id;
  final int idSender;
  final int idReceiver;
  final int idRessource;
  final DateTime datePartage;

  const Partage({
    required this.id,
    required this.idSender,
    required this.idReceiver,
    required this.idRessource,
    required this.datePartage,
  });

  factory Partage.fromJson(Map<String, dynamic> json) {
    return switch(json) {
      {
        'id' : int id,
        'idSender' : int idSender,
        'idReceiver' : int idReceiver,
        'idRessource' : int idRessource,
        'datePartage' : DateTime datePartage,
      } =>
      Partage(
        id: id,
        idSender: idSender,
        idReceiver: idReceiver,
        idRessource: idRessource,
        datePartage: datePartage,
      ),
      _ => throw const FormatException('Failed to create a Partage from JSON data.')
    };
  }
}