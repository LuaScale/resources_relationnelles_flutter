class RessourceType {
  final String titre;
  final String? slug;

  const RessourceType({
    required this.titre,
    this.slug,
  });

  factory RessourceType.fromJson(Map<String, dynamic> json) {
    final titre = json['title'] as String;
    final slug = json['slug'] as String?;
    return RessourceType(titre: titre, slug: slug);
  }
}