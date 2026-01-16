import '../../domain/entities/recipe_ingredient_entity.dart';

class RecipeIngredientModel extends RecipeIngredientEntity {
  const RecipeIngredientModel({
    required super.name,
    super.imageUrl,
  });

  factory RecipeIngredientModel.fromJson(Map<String, dynamic> json) {
    return RecipeIngredientModel(
      name: json['name'] as String? ?? 'Unknown Ingredient',
      imageUrl: json['image_url'] as String?, // Supabase uses image_url, Spoonacular uses image
    );
  }

  factory RecipeIngredientModel.fromSpoonacular(Map<String, dynamic> json) {
     // Spoonacular ingredients usually found in "extendedIngredients" -> "name", "image"
     // But here we are mapping a single ingredient object
     return RecipeIngredientModel(
      name: json['name'] as String? ?? '',
      imageUrl: json['image'] != null 
          ? 'https://spoonacular.com/cdn/ingredients_100x100/${json['image']}' 
          : null,
    );
  }
}
