class RessourceCategorie {
  final String? id;
  final String titre;
  final String? slug;

  const RessourceCategorie({
    this.id,
    required this.titre,
    this.slug,
  });

  factory RessourceCategorie.fromJson(Map<String, dynamic> json) {
    final id = json['@id'] as String?;
    final titre = json['title'] as String;
    final slug = json['slug'] as String?;
    return RessourceCategorie(id: id,titre: titre, slug: slug);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': titre,
      'slug': slug,
    };
  }
}