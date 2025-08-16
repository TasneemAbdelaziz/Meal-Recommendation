part of 'recipe_bloc.dart';

@immutable
sealed class RecipeEvent {}
final class RecipeUpload extends RecipeEvent{
  final String posterId;
  final String title;
  final String category;
  final String description;
  final List<String> ingredients;
  final int durationMinutes;
  final File image;
  final bool isFavorite;
  // final DateTime updatedAt;

  RecipeUpload(
      this.posterId,
      this.title,
      this.category,
      this.description,
      this.ingredients,
      this.durationMinutes,
      this.image,
      this.isFavorite,
      // this.updatedAt
      );
}
