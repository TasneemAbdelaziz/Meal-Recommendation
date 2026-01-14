import 'package:recipe_app_withai/features/ai_chat/domain/entities/recipe_suggestion.dart';

class RecipeSuggestionModel extends RecipeSuggestion {
  const RecipeSuggestionModel({
    required super.id,
    required super.title,
    required super.imageUrl,
  });

  // For complexSearch (byName)
  factory RecipeSuggestionModel.fromJson(Map<String, dynamic> json) {
    return RecipeSuggestionModel(
      id: json['id'] as int,
      title: json['title'] as String,
      imageUrl: json['image'] as String,
    );
  }

  // For findByIngredients (returns different structure generally, but usually has id, title, image)
  // Spoonacular findByIngredients returns list of objects with {id, title, image, ...}
  factory RecipeSuggestionModel.fromIngredientsJson(Map<String, dynamic> json) {
    return RecipeSuggestionModel(
      id: json['id'] as int,
      title: json['title'] as String,
      imageUrl: json['image'] as String,
    );
  }
}
