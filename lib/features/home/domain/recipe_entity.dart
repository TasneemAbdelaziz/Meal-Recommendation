class RecipeEntity {
  final String title;
  final String category;
  final int ingredientsCount;
  final String description;
  final List<String> ingredients;
  final int durationMinutes;
  final String? imagePath;
  bool isFavorite;

  RecipeEntity({
    required this.title,
    required this.category,
    required this.ingredientsCount,
    required this.description,
    required this.ingredients,
    required this.durationMinutes,
    this.imagePath,
    this.isFavorite = false,
  });

  factory RecipeEntity.fromMap(Map<String, dynamic> map) {
    return RecipeEntity(
      title: (map['title'] ?? '') as String,
      category: (map['category'] ?? '') as String,
      ingredientsCount: (map['ingredients_count'] ??
          ((map['ingredients'] as List?)?.length ?? 0)) as int,
      description: (map['description'] ?? '') as String,
      ingredients: ((map['ingredients'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      durationMinutes: (map['duration_minutes'] ?? 0) is int
          ? map['duration_minutes'] as int
          : int.tryParse('${map['duration_minutes']}') ?? 0,
      imagePath: map['image_url'] as String?,
      isFavorite: (map['is_favorite'] ?? false) as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'ingredients_count': ingredientsCount,
      'description': description,
      'ingredients': ingredients,
      'duration_minutes': durationMinutes,
      'image_url': imagePath,
      'is_favorite': isFavorite,
    };
  }

  RecipeEntity copyWith({
    String? title,
    String? category,
    int? ingredientsCount,
    String? description,
    List<String>? ingredients,
    int? durationMinutes,
    String? imagePath,
    bool? isFavorite,
  }) {
    return RecipeEntity(
      title: title ?? this.title,
      category: category ?? this.category,
      ingredientsCount: ingredientsCount ?? this.ingredientsCount,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      imagePath: imagePath ?? this.imagePath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
