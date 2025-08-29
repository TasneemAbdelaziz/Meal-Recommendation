import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/features/home/domian/entities/ingredient.dart';

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
  
  Future<Either<Failure, List<RecipeEntity>>> getRecipes();
  Future<Either<Failure, RecipeEntity>> toggleFavorite(String recipeId);
  
  List<RecipeEntity> getAllRecipes();
  void addRecipe(RecipeEntity recipe);
  List<RecipeEntity> getFavoriteRecipes();
}

