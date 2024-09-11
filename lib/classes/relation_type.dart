class RelationType {
  final String? id;
  final String titre;
  final String? slug;

  const RelationType({
    this.id,
    required this.titre,
    this.slug,
  });

  factory RelationType.fromJson(Map<String, dynamic> json) {
    final id = json['@id'] as String?;
    final titre = json['title'] as String;
    final slug = json['slug'] as String?;
    return RelationType(id: id,titre: titre, slug: slug);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': titre,
      'slug': slug,
    };
  }
}