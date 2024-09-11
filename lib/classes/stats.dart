class Stats {
  final int countAllRessource;
  final List<RessourceByCategory> ressourceByCategories;
  final Map<String, int> ressourceByDays;

  Stats({
    required this.countAllRessource,
    required this.ressourceByCategories,
    required this.ressourceByDays,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    var list = json['ressourceByCategories'] as List;
    List<RessourceByCategory> categoriesList = list.map((i) => RessourceByCategory.fromJson(i)).toList();

    return Stats(
      countAllRessource: json['countAllRessource'],
      ressourceByCategories: categoriesList,
      ressourceByDays: Map<String, int>.from(json['ressourceByDays']),
    );
  }
}

class RessourceByCategory {
  final String categoryName;
  final int ressourceCount;

  RessourceByCategory({
    required this.categoryName,
    required this.ressourceCount,
  });

  factory RessourceByCategory.fromJson(Map<String, dynamic> json) {
    return RessourceByCategory(
      categoryName: json['category_name'],
      ressourceCount: json['ressource_count'],
    );
  }
}
