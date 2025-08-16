class RecipeEntity {
  final String id;
  final String posterId;
  final String title;
  final String category;
  // final int ingredientsCount;
  final String description;
  final List<String> ingredients;
  final int durationMinutes;
  final String imagePath;
  final bool isFavorite;
  final DateTime updatedAt;

  RecipeEntity(
      {required this.id,
      required this.posterId,
      required this.title,
      required this.category,
      // required this.ingredientsCount,
      required this.description,
      required this.ingredients,
      required this.durationMinutes,
      required this.imagePath,
      required this.isFavorite,
      required this.updatedAt});


}
