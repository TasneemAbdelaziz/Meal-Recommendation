import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/features/add_recipe/data/models/recipe_model.dart';

abstract interface class FavoritesRepository {
  Future<Either<Failure, Set<String>>> getCachedFavoriteIds();

  Future<Either<Failure, Set<String>>> syncFavorites(String userId);

  Future<Either<Failure, Set<String>>> toggleFavorite({
    required String userId,
    required String recipeId,
  });


  Future<Either<Failure, Unit>> addFavorite({
    required String userId,
    required String recipeId,
  });

  Future<Either<Failure, Unit>> removeFavorite({
    required String userId,
    required String recipeId,
  });

  Future<Either<Failure, Unit>> clearCachedFavoriteIds();

  Future<List<RecipeModel>> getFavoriteRecipes(Set<String> recipeIds);

}
