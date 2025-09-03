import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/features/add_recipe/domian/entities/ingredient.dart';
import '../entities/recipe_entity.dart';

abstract interface class RecipeRepository {
  Future<Either<Failure,RecipeEntity>> uploadRecipe({
    required String title,
    required String category,
    required String description,
    required List<Ingredient> ingredients,
    required int durationMinutes,
    required File image,
    required bool isFavorite,
    required String posterId
});
  // List<RecipeEntity> getAllRecipes();
  // void addRecipe(RecipeEntity recipe);
  // // void toggleFavorite(RecipeEntity recipe);
  // List<RecipeEntity> getFavoriteRecipes();
}

