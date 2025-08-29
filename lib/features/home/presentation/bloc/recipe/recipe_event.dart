part of 'recipe_bloc.dart';

@immutable
sealed class RecipeEvent {}
final class RecipeUpload extends RecipeEvent{
  final String posterId;
  final String title;
  final String category;
  final String description;
  final  List<Ingredient> ingredients;
  final int durationMinutes;
  final File image;
  final bool isFavorite;
  // final DateTime updatedAt;

  RecipeUpload({
    required this.posterId,
    required this.title,
    required this.category,
    required this.description,
    required this.ingredients,
    required this.durationMinutes,
    required this.image,
    required this.isFavorite,
  });
}
