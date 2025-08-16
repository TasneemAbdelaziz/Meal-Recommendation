import 'dart:io';

import 'package:fpdart/src/either.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/features/home/data/data_sources/meal_remote_data_source.dart';
import 'package:recipe_app_withai/features/home/data/models/recipe_model.dart';
import 'package:recipe_app_withai/features/home/domian/repositories/recipe_repository.dart';

import 'package:recipe_app_withai/features/home/domian/entities/recipe_entity.dart';
import 'package:uuid/uuid.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource recipeRemoteDataSource;
  RecipeRepositoryImpl(this.recipeRemoteDataSource);
  final List<RecipeEntity> _recipes = [];

  @override
  List<RecipeEntity> getAllRecipes() => _recipes;

  @override
  void addRecipe(RecipeEntity recipe) {
    _recipes.add(recipe);
  }

  // @override
  // void toggleFavorite(RecipeEntity recipe) {
  //   final index = _recipes.indexOf(recipe);
  //   if (index != -1) {
  //     _recipes[index] = RecipeEntity(
  //       title: recipe.title,
  //       category: recipe.category,
  //
  //       // ingredientsCount: recipe.ingredientsCount,
  //       description: recipe.description,
  //       ingredients: recipe.ingredients,
  //       durationMinutes: recipe.durationMinutes,
  //       isFavorite: !recipe.isFavorite,
  //     );
  //   }
  // }

  @override
  List<RecipeEntity> getFavoriteRecipes() =>
      _recipes.where((r) => r.isFavorite).toList();

  @override
  Future<Either<Failure, RecipeEntity>> uploadRecipe({
    required String title,
    required String category,
    required String description,
    required List<String> ingredients,
    required int durationMinutes,
    required File image,
    required bool isFavorite,
    required String posterId
  }) async {
    try{
      RecipeModel recipeModel= RecipeModel(
          id: const Uuid().v1(),
          category: category,
          description: description,
          durationMinutes: durationMinutes,
          imagePath: "",
          ingredients: ingredients,
          isFavorite: isFavorite,
          posterId: posterId,
          title: title,
          updatedAt: DateTime.now());
       final imageUrl = await recipeRemoteDataSource.uploadMealImage(image: image, recipe: recipeModel);
      recipeModel = recipeModel.copyWith(imagePath:imageUrl );
      final uploadedRecipe = await recipeRemoteDataSource.uploadMeal(recipeModel);
      return right(uploadedRecipe);
    }
    on ServerFailure catch(e){
      return left(Failure(e.message));
    }

  }
}
