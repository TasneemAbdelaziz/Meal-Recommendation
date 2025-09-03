import 'dart:io';
import 'package:fpdart/src/either.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/features/add_recipe/data/data_sources/meal_remote_data_source.dart';
import 'package:recipe_app_withai/features/add_recipe/data/models/recipe_model.dart';
import 'package:recipe_app_withai/features/add_recipe/domian/entities/ingredient.dart';
import 'package:recipe_app_withai/features/add_recipe/domian/entities/recipe_entity.dart';
import 'package:recipe_app_withai/features/add_recipe/domian/repositories/recipe_repository.dart';

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
