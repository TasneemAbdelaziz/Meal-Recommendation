import 'dart:io';
import 'package:fpdart/src/either.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/features/home/data/data_sources/meal_remote_data_source.dart';
import 'package:recipe_app_withai/features/home/data/models/recipe_model.dart';
import 'package:recipe_app_withai/features/home/domian/entities/ingredient.dart';
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

  @override
  List<RecipeEntity> getFavoriteRecipes() =>
      _recipes.where((r) => r.isFavorite).toList();

  @override
  Future<Either<Failure, List<RecipeEntity>>> getRecipes() async {
    try {
      // For now, return the local recipes
      // In a real app, this would fetch from a remote source
      return right(_recipes);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecipeEntity>> toggleFavorite(String recipeId) async {
    try {
      final recipeIndex = _recipes.indexWhere((recipe) => recipe.id == recipeId);
      if (recipeIndex != -1) {
        final recipe = _recipes[recipeIndex];
        final updatedRecipe = RecipeEntity(
          id: recipe.id,
          posterId: recipe.posterId,
          title: recipe.title,
          category: recipe.category,
          description: recipe.description,
          ingredients: recipe.ingredients,
          durationMinutes: recipe.durationMinutes,
          imagePath: recipe.imagePath,
          isFavorite: !recipe.isFavorite,
          updatedAt: recipe.updatedAt,
        );
        _recipes[recipeIndex] = updatedRecipe;
        return right(updatedRecipe);
      } else {
        return left(Failure('Recipe not found'));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecipeEntity>> uploadRecipe({
    required String title,
    required String category,
    required String description,
    required List<Ingredient> ingredients,
    required int durationMinutes,
    required File image,
    required bool isFavorite,
    required String posterId
  }) async {
    print('🏪 Repository: بدء رفع الوصفة - $title');

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
      print('📸 رفع صورة الوصفة الرئيسية...');
      final imageUrl = await recipeRemoteDataSource.uploadMealImage(image: image, recipe: recipeModel);
      print('✅ صورة الوصفة رفعت إلى: $imageUrl');

      final ingredientImageUrls = await recipeRemoteDataSource.uploadIngredientImages(
        ingredients: ingredients,
        recipeId: recipeModel.id,
      );
      List<Ingredient> updatedIngredients = [];
      for (int i = 0; i < ingredients.length; i++) {
        updatedIngredients.add(
            Ingredient(
              name: ingredients[i].name,
              imagePath: ingredientImageUrls[i],
            )
        );
      }

      print('📦 رفع بيانات الوصفة إلى Supabase...');

      recipeModel = recipeModel.copyWith(imagePath:imageUrl,ingredients: updatedIngredients );
      final uploadedRecipe = await recipeRemoteDataSource.uploadMeal(recipeModel);
      print('🎉 تم رفع الوصفة بنجاح: ${uploadedRecipe.title}');

      return right(uploadedRecipe);

    }
    on ServerFailure catch(e){
      print('❌ فشل في الرفع: ${e.message}');
      print('❌ خطأ غير متوقع: $e');

      return left(Failure(e.message));
    }

  }
}
