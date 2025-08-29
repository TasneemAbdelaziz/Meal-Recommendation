import 'package:fpdart/src/either.dart';
import 'package:recipe_app_withai/core/entity/recipe_entity.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import '../data_source/suggested_Meals.dart';
import '../models/ImageModel.dart';
import '../models/suggestedMealModel.dart';

class RecipeRepository {
  final RecipeRemoteDatasource remoteDatasource;

  RecipeRepository(this.remoteDatasource);

  Future<AIMeal> getRecipeSuggestions(String ingredients) async {
    final result = await remoteDatasource.getRecipeSuggestions(ingredients);
    return result;
  }

  Future<ImageModel> getDishImage(String dishName) async {
    final result = await remoteDatasource.getDishImage(dishName);
    return result;
  }

  Future<Either<Failure, List<RecipeEntity>>> getRecipes() async {
    // Implementation for getting recipes
    throw UnimplementedError();
  }

  Future<Either<Failure, RecipeEntity>> toggleFavorite(String recipeId) async {
    // Implementation for toggling favorite
    throw UnimplementedError();
  }
}