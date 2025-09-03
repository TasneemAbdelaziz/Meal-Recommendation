import 'package:recipe_app_withai/features/home/data/models/recipe_model.dart';
import 'package:recipe_app_withai/features/home/domain/entities/recipe_entity.dart';

abstract interface class HomeRepository {
  Future<List<RecipeEntity>> getAllRecipes();
  // Future<List<RecipeEntity>> searchRecipes(String query);
  // Future<List<RecipeEntity>> getRecipesByDuration(int maxDuration);
}