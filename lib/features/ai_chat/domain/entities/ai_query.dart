class AiQuery {
  final String mode; // "byName" or "byIngredients"
  final String? query;
  final List<String> ingredients;
  final int? maxReadyTime;
  final String? cuisine;

  const AiQuery({
    required this.mode,
    this.query,
    this.ingredients = const [],
    this.maxReadyTime,
    this.cuisine,
  });
}
